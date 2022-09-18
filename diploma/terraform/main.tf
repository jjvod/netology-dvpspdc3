# terraform {
#     backend "s3" {
#     endpoint                    = "storage.yandexcloud.net"
#     bucket                      = "devops-diplom-yandexcloud"
#     region                      = "ru-central1"
#     key                         = "terraform.tfstate"
#     access_key = ""
#     secret_key = ""
#     skip_region_validation      = true
#     skip_credentials_validation = true
#   }
# }

resource "yandex_compute_instance" "nat_instance" {
  name     = "nat"
  hostname = "nat"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd84mnpg35f7s7b0f5lg"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_vpc_subnet.id
    nat_ip_address = "51.250.88.230"
    nat       = true
  }

  metadata = {
    test     = "test_str"
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}

locals{
  instance_map={
    "db01_instance"       = {name = "mysql-master", cores = 4, memory = 4, size = 10},
    "db02_instance"       = {name = "mysql-slave",  cores = 4, memory = 4, size = 10},
    "app_instance"        = {name = "wordpress",    cores = 4, memory = 4, size = 10},
    "monitoring_instance" = {name = "monitoring",   cores = 4, memory = 4, size = 10},
    "gitlab_instance"     = {name = "gitlab",       cores = 8, memory = 8, size = 30},
    "runner_instance"     = {name = "runner",       cores = 4, memory = 4, size = 30}
  }
}

resource "yandex_compute_instance" "instances" {
  for_each = local.instance_map
  name     = "${each.value.name}"
  hostname = "${each.value.name}"
  zone     = "ru-central1-a"

  resources {
    cores  = "${each.value.cores}"
    memory = "${each.value.memory}"
  }

  boot_disk {
    initialize_params {
      image_id = "fd81d2d9ifd50gmvc03g"
      size     = "${each.value.size}"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_vpc_subnet.id
  }

  metadata = {
    ssh-keys = "ubuntu:${var.SSH_ID_RSA_PUB}"
  }
}