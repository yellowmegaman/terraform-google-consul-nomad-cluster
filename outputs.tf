output "external-ips" {
  value = ["${google_compute_instance.vm.*.network_interface.0.access_config.0.assigned_nat_ip}"]
}
output "internal-ips" {
  value = ["${google_compute_instance.vm.*.network_interface.0.address}"]
}
output "datacenter" {
  value = "${var.datacenter}"
}
output "tag" {
  value = "${var.tag}"
}
output "count" {
  value = "${var.count}"
}
