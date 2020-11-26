provider "google" {
  project = "mystic-fountain-258616"
  region  = "europe-west6"
  zone    = "europe-west6-a"
  version = "~> 3.45"
}

data "terraform_remote_state" "service_account" {
  backend = "local"

  config = {
    path = "${path.module}/../service-account/terraform.tfstate"
  }
}

resource "google_storage_bucket" "artifact_store" {
  name          = "peklak_artifact_store"
  location      = "europe-west6"
  storage_class = "REGIONAL"
  force_destroy = true

  uniform_bucket_level_access = true
}


resource "google_storage_bucket_iam_binding" "artifact_store_host_iam_binding" {
  bucket = google_storage_bucket.artifact_store.name
  role = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${data.terraform_remote_state.service_account.outputs.host_service_account_email}",
  ]
}

resource "google_storage_bucket_iam_binding" "artifact_store__bulid_iam_binding" {
  bucket = google_storage_bucket.artifact_store.name
  role = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${data.terraform_remote_state.service_account.outputs.build_service_account_email}",
  ]
}
