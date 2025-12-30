variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "name_prefix" { type = string }

variable "vnet_address_space" { type = list(string) }

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}
variable "allowed_ssh_source_cidrs" {
  description = "CIDRs allowed to SSH into public subnet (e.g. your public IP /32). Empty disables SSH."
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "Tags to apply to NSGs"
  type        = map(string)
  default     = {}
}
variable "vm_admin_username" {
  description = "Admin username for the dev VM"
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_public_key_path" {
  description = "Path to the SSH public key on your machine"
  type        = string
}

variable "vm_size" {
  description = "Dev VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "alert_email" {
  description = "Email address to receive Azure Monitor alerts."
  type        = string
}