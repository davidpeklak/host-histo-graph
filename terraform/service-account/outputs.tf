output "host_service_account_email" {
  value       = google_service_account.host_service_account.email
  description = "host service account email"
}

output "build_service_account_email" {
  value       = google_service_account.build_service_account.email
  description = "build service account email"
}
