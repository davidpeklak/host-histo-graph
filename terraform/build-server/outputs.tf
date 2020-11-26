output "host_public_ip" {
  value       = google_compute_instance.build_server.network_interface.0.access_config.0.nat_ip
  description = "Public ip of vm"
}

output "host_id" {
  value       = google_compute_instance.build_server.id
  description = "id of vm"
}
