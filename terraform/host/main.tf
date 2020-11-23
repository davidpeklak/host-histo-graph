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

resource "google_dns_managed_zone" "peklak" {
  name        = "peklak"
  dns_name    = "peklak.ch."
  description = "peklak.ch DNS zone"
}


resource "google_compute_instance" "host" {
  name         = "host"
  machine_type = "f1-micro"

  tags = ["web"]

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
    email = data.terraform_remote_state.service_account.outputs.host_service_account_email
    scopes = ["storage-full"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}

resource "google_dns_record_set" "a" {
  name         = "${google_dns_managed_zone.peklak.dns_name}"
  managed_zone = google_dns_managed_zone.peklak.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.host.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "cname" {
  name         = "www.${google_dns_managed_zone.peklak.dns_name}"
  managed_zone = google_dns_managed_zone.peklak.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${google_dns_managed_zone.peklak.dns_name}"]
}
