provider "google" {
  project = "mystic-fountain-258616"
  region  = "europe-west6"
  zone    = "europe-west6-a"
}

resource "google_dns_managed_zone" "peklak" {
  name        = "peklak"
  dns_name    = "peklak.ch."
  description = "peklak.ch DNS zone"
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
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
    ssh-keys = "dpeklak:${file("terrakey.pub")}"
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

  rrdatas = [google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "cname" {
  name         = "www.${google_dns_managed_zone.peklak.dns_name}"
  managed_zone = google_dns_managed_zone.peklak.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["${google_dns_managed_zone.peklak.dns_name}"]
}

output "vm_public_ip" {
  value       = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
  description = "Public ip of vm"
}

output "name_servers" {
  value       = google_dns_managed_zone.peklak.name_servers
  description = "Name servers"
}
