output "vm_public_ip" {
  value       = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
  description = "Public ip of vm"
}

output "name_servers" {
  value       = google_dns_managed_zone.peklak.name_servers
  description = "Name servers"
}
