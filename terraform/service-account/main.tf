provider "google" {
  project = "mystic-fountain-258616"
  region  = "europe-west6"
  zone    = "europe-west6-a"
  version = "~> 3.45"
}

resource "google_service_account" "host_service_account" {
  account_id   = "host-service-account"
  display_name = "Host Service Account"
}
