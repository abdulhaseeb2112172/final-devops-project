variable "resource_group_name" {
  default = "devops-rg"
}

variable "location" {
  default = "East US"
}

variable "admin_username" {
  default = "azureuser"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
