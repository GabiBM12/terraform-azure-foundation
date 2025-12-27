variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  description = "Map of subnet name => { address_prefixes = [...] }"
  type = map(object({
    address_prefixes = list(string)
  }))
}