terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.221.0"
    }
  }
}

# YC_TOKEN, YC_CLOUD_ID и YC_FOLDER_ID передаются через переменные окружения.
# Благодаря этому временный IAM-токен и идентификаторы облака не попадают в Git.
provider "yandex" {
  zone = var.zone
}

locals {
  labels = {
    project     = var.project_name
    environment = "homework"
    managed_by  = "terraform"
  }
}

# Актуальный образ Ubuntu выбирается по семейству, поэтому в конфигурации не
# зафиксирован идентификатор конкретной версии образа.
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_vpc_network" "platform" {
  name        = "${var.project_name}-network"
  description = "Network for the Future 2.0 Task4 training stand"
  labels      = local.labels
}

resource "yandex_vpc_subnet" "platform" {
  name           = "${var.project_name}-subnet"
  description    = "Single subnet for the Task4 training stand"
  zone           = var.zone
  network_id     = yandex_vpc_network.platform.id
  v4_cidr_blocks = var.subnet_cidrs
  labels         = local.labels
}

resource "yandex_vpc_security_group" "platform" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH from the administrator address and outbound traffic"
  network_id  = yandex_vpc_network.platform.id
  labels      = local.labels

  ingress {
    description    = "SSH from the administrator address only"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.admin_cidr]
  }

  egress {
    description    = "Package downloads and access to Yandex Cloud APIs"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Данные отделены от загрузочного диска. В учебном стенде этот диск можно
# использовать для каталога MinIO или других демонстрационных данных.
resource "yandex_compute_disk" "data" {
  name        = "${var.project_name}-data"
  description = "Data disk for the single-node platform prototype"
  type        = var.disk_type
  zone        = var.zone
  size        = var.data_disk_size_gb
  labels      = local.labels
}

resource "yandex_compute_instance" "platform" {
  name                      = "${var.project_name}-vm"
  hostname                  = "${var.project_name}-vm"
  description               = "Single-node non-production data platform stand"
  platform_id               = var.platform_id
  zone                      = var.zone
  allow_stopping_for_update = true
  labels                    = local.labels

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory_gb
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = var.disk_type
      size     = var.boot_disk_size_gb
    }
  }

  secondary_disk {
    disk_id     = yandex_compute_disk.data.id
    auto_delete = false
    device_name = "data"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.platform.id
    security_group_ids = [yandex_vpc_security_group.platform.id]

    # Для короткоживущего учебного стенда используется динамический внешний
    # IPv4 через one-to-one NAT. Отдельный NAT Gateway здесь избыточен.
    nat = true
  }

  metadata = {
    "ssh-keys" = "${var.vm_user}:${trimspace(file(pathexpand(var.ssh_public_key_path)))}"
  }

  scheduling_policy {
    preemptible = var.preemptible
  }
}
