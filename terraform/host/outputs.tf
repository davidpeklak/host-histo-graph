output "host_public_ip" {
  value       = google_compute_instance.host.network_interface.0.access_config.0.nat_ip
  description = "Public ip of vm"
}

output "host_id" {
  value       = google_compute_instance.host.id
  description = "id of vm"
}

output "name_servers" {
  value       = google_dns_managed_zone.peklak.name_servers
  description = "Name servers"
}
