variable "name_prefix" {
    description = "A prefix to use for naming resources"
    type = string

}
variable "resource_group_name" {
    description = "Resource group where NSGs will be created"
    type = string
  
}
variable "location" {
    description = "Azure region"
    type = string

}
variable "subnet_ids" {
    description = "List of subnet IDs to source the NSGs from"
    type = map(string)

}
variable "allowed_ssh_source_cidrs" {
    description = "List of CIDR blocks allowed to access SSH"
    type = list(string)
    default = []

}
variable "tags" {
    description = "Tags applied to NSGs"
    type = map(string)
    default = {}
  
}
variable "enable_bastion_developer" {
  description = "Enable inbound SSH from Azure Bastion Developer platform IP (168.63.129.16) to private subnet."
  type        = bool
  default     = true
}