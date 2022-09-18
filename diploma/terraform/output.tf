# output "entrance_jjvodvoevodin_ru_ip_addr_external" {
#   value = yandex_compute_instance.entrance_instance.network_interface.0.nat_ip_address
# }

# output "db01_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["db01_instance"].network_interface.0.ip_address
# }

# output "db02_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["db02_instance"].network_interface.0.ip_address
# }

# output "app_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["app_instance"].network_interface.0.ip_address
# }

# output "monitoring_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["monitoring_instance"].network_interface.0.ip_address
# }

# output "gitlab_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["gitlab_instance"].network_interface.0.ip_address
# }

# output "runner_jjvodvoevodin_ru_ip_addr_internal" {
#   value = yandex_compute_instance.instances["runner_instance"].network_interface.0.ip_address
# }

# output "ssh_config" {
#   value = <<-EOT
#   Host jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["entrance_instance.network_interface.0.nat_ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa

#   Host db01.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["db01_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host db02.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["db02_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host app.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["app_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host monitoring.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["monitoring_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host gitlab.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["gitlab_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   Host runner.jjvod-voevodin.ru
#     HostName ${yandex_compute_instance.instances["runner_instance.network_interface.0.ip_address}
#     User ubuntu
#     IdentityFile ~/.ssh/id_rsa
#       ProxyJump ubuntu@${yandex_compute_instance.instances["nat_instance.network_interface.0.nat_ip_address}
#       ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

#   EOT
# }
