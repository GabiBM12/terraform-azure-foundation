variable "name_prefix" {
  description = "Prefix for naming"
  type        = string
  
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  
}
variable "location" {
    description = "Azure location"
    type        = string
}
 
variable "virtual_network_id" {
    description = "Id of the virtual network"
    type = string
} 

variable "tags" {
    description = "Tags to be applied"
    type        = map(string)
    default     = {}
}
  
