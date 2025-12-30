output "workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}
output "linux_dcr_id" {
  value       = azurerm_monitor_data_collection_rule.linux_baseline.id
  description = "Data Collection Rule for Linux Baseline"
  
}