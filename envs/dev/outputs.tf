output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.this.name
}
output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = module.network.subnet_ids
}
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = module.monitoring.workspace_id
}
output "nsg_ids" {
  description = "NSG IDs for dev environment"
  value       = module.security.nsg_ids
}