output "external-ips" {
  value = ["${google_compute_instance.vm.*.network_interface.0.access_config.0.nat_ip}"]
}
output "internal-ips" {
  value = ["${google_compute_instance.vm.*.network_interface.0.network_ip}"]
}
output "datacenter" {
  value = "${var.datacenter}"
}
output "tag" {
  value = "${var.tag}"
}
output "worker_count" {
  value = "${var.worker_count}"
}
