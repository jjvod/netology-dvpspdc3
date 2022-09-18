# # Generate ssh config for ansible
# resource "local_file" "ssh_config" {
#   content = <<-EOT
#   User ubuntu
#   IdentityFile ~/.ssh/id_rsa

#   Host jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.entrance_instance.network_interface.0.nat_ip_address}

#   Host db01.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["db01_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host db02.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["db02_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host app.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["app_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host monitoring.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["monitoring_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host gitlab.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["gitlab_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host runner.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["runner_instance"].network_interface.0.ip_address}
#       ProxyJump ubuntu@${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa
#   EOT
#   filename = "./ssh_config"

#   depends_on = [
#     yandex_compute_instance.entrance_instance,
#     yandex_compute_instance.nat_instance,
#     yandex_compute_instance.instances["db01_instance"],
#     yandex_compute_instance.instances["db02_instance"],
#     yandex_compute_instance.instances["app_instance"],
#     yandex_compute_instance.instances["monitoring_instance"],
#     yandex_compute_instance.instances["gitlab_instance"],
#     yandex_compute_instance.instances["runner_instance"]
#   ]
# }

# # Generate variables for ansible
# resource "local_file" "ansible_var" {
#   content = <<-EOT
#   app_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["app_instance"].network_interface.0.ip_address}"
#   db01_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["db01_instance"].network_interface.0.ip_address}"
#   db02_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["db02_instance"].network_interface.0.ip_address}"
#   entrance_jjvodvoevodin_ru_ip_addr_external: "${yandex_compute_instance.nat_instance.network_interface.0.nat_ip_address}"
#   entrance_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.nat_instance.network_interface.0.ip_address}"
#   gitlab_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["gitlab_instance"].network_interface.0.ip_address}"
#   monitoring_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["monitoring_instance"].network_interface.0.ip_address}"
#   runner_jjvodvoevodin_ru_ip_addr_internal: "${yandex_compute_instance.instances["runner_instance"].network_interface.0.ip_address}"
#   EOT
#   filename = "../ansible/roles/variables.yml"

#   depends_on = [
#     # yandex_compute_instance.entrance_instance,
#     yandex_compute_instance.nat_instance,
#     yandex_compute_instance.instances["db01_instance"],
#     yandex_compute_instance.instances["db02_instance"],
#     yandex_compute_instance.instances["app_instance"],
#     yandex_compute_instance.instances["monitoring_instance"],
#     yandex_compute_instance.instances["gitlab_instance"],
#     yandex_compute_instance.instances["runner_instance"]
#   ]

# #  depends_on = [local_file.ssh_config]
# }
