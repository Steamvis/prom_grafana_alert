resource "google_compute_network" "default" {
  name = "network-grafana-prometheus"
}

resource "google_compute_firewall" "monitoring" {
  name    = "monitoring-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "9090", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["monitoring"]
}
resource "google_compute_firewall" "app" {
  name    = "app-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "9100"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["app"]
}
