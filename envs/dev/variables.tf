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