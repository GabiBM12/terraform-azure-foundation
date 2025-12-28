output "vm_id" {
  description = "VM resource ID"
  value       = azurerm_linux_virtual_machine.this.id
}

output "nic_id" {
  description = "NIC resource ID"
  value       = azurerm_network_interface.this.id
}

output "private_ip" {
  description = "VM private IP address"
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}