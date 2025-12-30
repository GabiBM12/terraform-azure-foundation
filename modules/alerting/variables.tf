variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "action_group_name" {
  type    = string
  default = "ag-core-alerts"
}

variable "short_name" {
  type    = string
  default = "corealrt"
}

variable "email_address" {
  type = string
}

variable "vm_id" {
  description = "Target VM resource ID (for metric alerts)."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace resource ID (scope for scheduled query rules)."
  type        = string
}

variable "cpu_threshold_pct" {
  type    = number
  default = 80
}

variable "disk_free_threshold_pct" {
  type    = number
  default = 15
}

# Used in KQL filters. Keep this simple for dev.
variable "computer_name_contains" {
  type    = string
  default = "dev-foundation"
}