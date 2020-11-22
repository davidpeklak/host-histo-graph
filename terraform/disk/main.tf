provider "google" {
  project = "mystic-fountain-258616"
  region  = "europe-west6"
  zone    = "europe-west6-a"
  version = "~> 3.45"
}

data "terraform_remote_state" "host" {
  backend = "local"

  config = {
    path = "${path.module}/../host/terraform.tfstate"
  }
}

resource "google_compute_disk" "artifact-disk" {
  name  = "artifact-disk"
  zone  = "europe-west6-a"
  size  = 10
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.artifact-disk.id
  instance = data.terraform_remote_state.host.outputs.vm_id
}
