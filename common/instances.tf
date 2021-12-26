resource "google_compute_instance" "prometheus_grafana" {
  name         = "monitoring"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.default.name
    access_config {
      // Ephemeral public IP
    }
  }

  tags = toset(google_compute_firewall.monitoring.source_tags)
}

resource "google_compute_instance" "app" {
  name         = "app"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.default.name
    access_config {
      // Ephemeral public IP
    }
  }

  tags = toset(google_compute_firewall.app.source_tags)
}