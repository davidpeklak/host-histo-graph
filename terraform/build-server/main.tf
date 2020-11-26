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

resource "google_compute_instance" "build_server" {
  name         = "build-server"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "dpeklak:${file("../../terrakey.pub")}"
  }

  service_account {
    email = data.terraform_remote_state.service_account.outputs.build_service_account_email
    scopes = ["storage-full"]
  }
}
