variable "project_name" {
  description = "Prefix used in names and labels of all stand resources."
  type        = string
  default     = "future20-task4"

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{1,61}[a-z0-9])?$", var.project_name))
    error_message = "project_name must be a lowercase Yandex Cloud compatible name."
  }
}

variable "zone" {
  description = "Yandex Cloud availability zone for the subnet, VM and disks."
  type        = string
  default     = "ru-central1-d"
}

variable "subnet_cidrs" {
  description = "IPv4 CIDR blocks allocated to the training subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]

  validation {
    condition     = length(var.subnet_cidrs) > 0 && alltrue([for cidr in var.subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "subnet_cidrs must contain at least one valid IPv4 CIDR block."
  }
}

variable "admin_cidr" {
  description = "Public administrator IPv4 address in CIDR notation allowed to connect over SSH."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0))
    error_message = "admin_cidr must be a valid CIDR, normally a single address with /32."
  }
}

variable "vm_user" {
  description = "Linux user to which the public SSH key is assigned."
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Local path to an existing public SSH key. The private key is never read by Terraform."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "image_family" {
  description = "Yandex Cloud Compute image family used for the boot disk."
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "platform_id" {
  description = "Yandex Compute Cloud hardware platform."
  type        = string
  default     = "standard-v3"
}

variable "vm_cores" {
  description = "Number of vCPU cores of the prototype VM."
  type        = number
  default     = 2

  validation {
    condition     = contains([2, 4, 6, 8, 10, 12, 16, 20, 24, 28, 32, 36, 40], var.vm_cores)
    error_message = "vm_cores must be a supported even number of vCPU cores."
  }
}

variable "vm_memory_gb" {
  description = "RAM of the prototype VM in GiB."
  type        = number
  default     = 4

  validation {
    condition     = var.vm_memory_gb >= 2
    error_message = "vm_memory_gb must be at least 2 GiB."
  }
}

variable "vm_core_fraction" {
  description = "Guaranteed fraction of vCPU performance in percent."
  type        = number
  default     = 20

  validation {
    condition     = contains([20, 50, 100], var.vm_core_fraction)
    error_message = "vm_core_fraction must be 20, 50 or 100 for the selected platform."
  }
}

variable "disk_type" {
  description = "Yandex Compute Cloud disk type used by the stand."
  type        = string
  default     = "network-hdd"

  validation {
    condition     = contains(["network-hdd", "network-ssd"], var.disk_type)
    error_message = "disk_type must be network-hdd or network-ssd."
  }
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_size_gb >= 10 && floor(var.boot_disk_size_gb) == var.boot_disk_size_gb
    error_message = "boot_disk_size_gb must be an integer of at least 10 GiB."
  }
}

variable "data_disk_size_gb" {
  description = "Separate data disk size in GiB."
  type        = number
  default     = 30

  validation {
    condition     = var.data_disk_size_gb >= 10 && floor(var.data_disk_size_gb) == var.data_disk_size_gb
    error_message = "data_disk_size_gb must be an integer of at least 10 GiB."
  }
}

variable "preemptible" {
  description = "Use an interruptible VM to reduce the cost of the short-lived training stand."
  type        = bool
  default     = true
}
