output "vm_id" {
  description = "ID of the prototype VM."
  value       = yandex_compute_instance.platform.id
}

output "vm_internal_ip" {
  description = "Internal IPv4 address of the prototype VM."
  value       = yandex_compute_instance.platform.network_interface[0].ip_address
}

output "vm_public_ip" {
  description = "Dynamic public IPv4 address assigned through NAT."
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "ssh_command" {
  description = "Command for connecting to the VM after apply."
  value       = "ssh ${var.vm_user}@${yandex_compute_instance.platform.network_interface[0].nat_ip_address}"
}

output "network_id" {
  description = "ID of the created VPC network."
  value       = yandex_vpc_network.platform.id
}

output "subnet_id" {
  description = "ID of the created subnet."
  value       = yandex_vpc_subnet.platform.id
}

output "security_group_id" {
  description = "ID of the security group attached to the VM."
  value       = yandex_vpc_security_group.platform.id
}

output "data_disk_id" {
  description = "ID of the separate data disk."
  value       = yandex_compute_disk.data.id
}

output "data_disk_device" {
  description = "Stable Linux path expected for the attached data disk."
  value       = "/dev/disk/by-id/virtio-data"
}
