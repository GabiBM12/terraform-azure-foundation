variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "name_prefix" { type = string }

variable "vnet_address_space" { type = list(string) }

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}