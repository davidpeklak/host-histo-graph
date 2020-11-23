output "host_service_account_email" {
  value       = google_service_account.host_service_account.email
  description = "host_service_account_email"
}
