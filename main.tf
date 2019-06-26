data "template_file" "consul-config" {
  template = "${file("${path.module}/templates/consul.hcl")}"
  vars = {
    bootstrap_expect = "${var.mode == "server" ? var.worker_count : 0}"
    datacenter       = "${var.datacenter}"
    consul_key       = "${var.consul_key}"
    server_bool      = "${var.mode == "server" ? "true" : "false" }"
    cloud-auto-join  = "[\"provider=gce tag_value=${var.tag}\"]"
  }
}

data "template_file" "nomad-config" {
  template = "${file("${path.module}/templates/nomad.hcl")}"
  vars = {
    server_bool      = "${var.mode == "server" ? "true" : "false" }"
    bootstrap_expect = "${var.mode == "server" ? var.worker_count : 0}"
    datacenter       = "${var.datacenter}"
    client_bool      = "${(var.mode == "server" && var.nomad-dense == "true") || (var.mode != "server") ? "true" : "false" }"
  }
}

resource "google_compute_instance" "vm" {
  lifecycle {
      ignore_changes = [
          "attached_disk"
      ]
  }
  allow_stopping_for_update = true
  count        = "${var.worker_count}"
  name         = "${var.tag}-${var.mode}-${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["${var.tag}", "${var.network_tags}"]
  service_account {
    scopes     = "${var.scopes}"
  }

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.disk_size}"
      type  = "${var.disk_type}"
    }
  }

  metadata = {
    tag         = "${var.tag}"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  provisioner "file" {
    content     = "${data.template_file.consul-config.rendered}"
    destination = "/tmp/consul.hcl"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      agent       = false
      user        = "${var.ssh_user}"
      private_key = "${var.ssh_key}"
      timeout     = "5m"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.nomad-config.rendered}"
    destination = "/tmp/nomad.hcl"
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      agent       = false
      user        = "${var.ssh_user}"
      private_key = "${var.ssh_key}"
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    inline = [
	"sudo mv /tmp/consul.hcl /etc/consul/consul.hcl",
	"sudo mv /tmp/nomad.hcl /etc/nomad/nomad.hcl",
	"sudo systemctl enable --now consul nomad",
	"${var.cmd != "" ? var.cmd : "echo"}"
    ]
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      agent       = false
      user        = "${var.ssh_user}"
      private_key = "${var.ssh_key}"
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "sudo nomad node -drain -self -enable -yes",
      "sudo consul leave",
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      agent       = false
      user        = "${var.ssh_user}"
      private_key = "${var.ssh_key}"
      timeout     = "5m"
    }
  }
}
