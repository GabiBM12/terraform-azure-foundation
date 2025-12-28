variable "name_prefix" {
    description = "Prefix for naming"
    type = string 
  
}
variable "resource_group_name"  {
    description = "Name of the reosurce group"
    type = string

}
variable "location" {
    description = "Azure region"
    type = string

}
variable "subnet_id" {
    description = "ID of the subnet where the VMs NIC will be placed"
    type = string
  
}
variable "admin_username" {
    description = "Admin username for the VM"
    type = string

}
variable "ssh_public_key" {
    description = "SSH public key for VM access(not a path).Use file in env to load from disk"
    type = string

}
variable "vm_size" {
    description = "size of the VM to be created"
    type = string 

}
variable "os_disk_type" {
    description = "Type of OS disk to be created"
    type = string
    default = "Standard_LRS"
  
}
variable "tags" {
    description = "Tags to be applied"
    type        = map(string)
    default     = {}
  
}
  