# Перед plan/apply замените адрес TEST-NET на свой текущий публичный IPv4 /32.
# Например: admin_cidr = "198.51.100.25/32"
admin_cidr = "176.192.221.83/32"

project_name        = "future20-task4"
zone                = "ru-central1-d"
subnet_cidrs        = ["10.10.1.0/24"]
vm_user             = "ubuntu"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"

image_family     = "ubuntu-2204-lts"
platform_id      = "standard-v3"
vm_cores         = 2
vm_memory_gb     = 4
vm_core_fraction = 20
preemptible      = true

disk_type         = "network-hdd"
boot_disk_size_gb = 20
data_disk_size_gb = 30
