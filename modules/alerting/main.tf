resource "azurerm_monitor_action_group" "core" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  email_receiver {
    name          = "primary"
    email_address = var.email_address
  }
}

# 1) CPU > threshold (metric alert)
resource "azurerm_monitor_metric_alert" "vm_cpu_high" {
  name                = "alert-vm-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.vm_id]
  description         = "VM CPU > ${var.cpu_threshold_pct}% for 10 minutes"
  severity            = 2
  enabled             = true

  frequency   = "PT1M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold_pct
  }

  action {
    action_group_id = azurerm_monitor_action_group.core.id
  }
}

# 2) Heartbeat missing (log alert)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm_heartbeat_missing" {
  name                = "alert-vm-heartbeat-missing"
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes                 = [var.log_analytics_workspace_id]
  description            = "No heartbeat from VM in last 10 minutes"
  enabled                = true
  severity               = 2
  evaluation_frequency   = "PT5M"
  window_duration        = "PT10M"
  auto_mitigation_enabled = true

  criteria {
    query = <<-KQL
      Heartbeat
      | where TimeGenerated > ago(10m)
      | where Computer contains "${var.computer_name_contains}"
      | summarize HeartbeatCount=count()
    KQL

    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "LessThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.core.id]
  }
}

# 3) Disk free space low (log alert from Perf)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm_disk_low" {
  name                = "alert-vm-disk-low"
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes                 = [var.log_analytics_workspace_id]
  description            = "Disk free space below ${var.disk_free_threshold_pct}%"
  enabled                = true
  severity               = 2
  evaluation_frequency   = "PT5M"
  window_duration        = "PT10M"
  auto_mitigation_enabled = true

  criteria {
    query = <<-KQL
      Perf
      | where TimeGenerated > ago(10m)
      | where ObjectName == "LogicalDisk" and CounterName == "% Free Space"
      | where Computer contains "${var.computer_name_contains}"
      | summarize AvgFreePct=avg(CounterValue) by Computer, InstanceName
      | where InstanceName !in ("_Total")
      | where AvgFreePct < ${var.disk_free_threshold_pct}
      | summarize MatchCount=count()
    KQL

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.core.id]
  }
}

# 4) SSH failed password spike (log alert from Syslog)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "ssh_failed_password_spike" {
  name                = "alert-ssh-failed-password-spike"
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes                 = [var.log_analytics_workspace_id]
  description            = "Spike of SSH failed password attempts"
  enabled                = true
  severity               = 2
  evaluation_frequency   = "PT5M"
  window_duration        = "PT10M"
  auto_mitigation_enabled = true

  criteria {
    query = <<-KQL
      Syslog
      | where TimeGenerated > ago(10m)
      | where Computer contains "${var.computer_name_contains}"
      | where SyslogMessage has "Failed password"
      | summarize FailCount=count()
      | where FailCount >= 5
      | summarize MatchCount=count()
    KQL

    time_aggregation_method = "Count"
    threshold               = 0
    operator                = "GreaterThan"
  }

  action {
    action_groups = [azurerm_monitor_action_group.core.id]
  }
}