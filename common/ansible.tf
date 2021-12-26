locals {
  vars_for_ansible = jsondecode(
    file("${path.module}/.vars")
  )
}

resource "local_file" "ansible_hosts_file" {
  content    = <<-EOT
[monitoring]
${google_compute_instance.prometheus_grafana.network_interface.0.access_config.0.nat_ip}
[app]
%{ for app_ip in google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip ~}
${app_ip}
%{ endfor ~}
  EOT
  filename   = "${path.module}/ansible/hosts"
  depends_on = [google_compute_instance.prometheus_grafana, google_compute_instance.app]
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.ansible_hosts_file]
  provisioner "local-exec" {
    command = <<-EOT
export ANSIBLE_HOST_KEY_CHECKING=False;
ansible-playbook ${path.module}/ansible/playbook.yaml -i ${path.module}/ansible/hosts \
-e "remote_user=${var.remote_user} pass='${local.vars_for_ansible["basic_auth_password"]}' smtp_smarthost='${local.vars_for_ansible["smtp_smarthost"]}' smtp_auth_username='${local.vars_for_ansible["smtp_auth_username"]}' smtp_auth_password='${local.vars_for_ansible["smtp_auth_password"]}' main_receiver_email='${local.vars_for_ansible["main_receiver_email"]}' urgent_receiver_email='${local.vars_for_ansible["urgent_receiver_email"]}'"
    EOT
  }
}