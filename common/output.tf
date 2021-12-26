output "grafana_address" {
  value = "${google_compute_instance.prometheus_grafana.network_interface.0.access_config.0.nat_ip}:3000"
}

output "prometheus_address" {
  value = "${google_compute_instance.prometheus_grafana.network_interface.0.access_config.0.nat_ip}:9090"
}

output "node_exporter_address" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}:9100"
}

output "app_ip" {
  value = google_compute_instance.app.network_interface.0.access_config.0.nat_ip
}


