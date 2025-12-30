resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.sku
  retention_in_days = var.retention_in_days
}
resource "azurerm_monitor_diagnostic_setting" "bastion" {
  name                       = "$diag-bastion"
  target_resource_id         = var.bastion_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "BastionAuditLogs"
  
 
    }
    enabled_metric {
      category = "AllMetrics"
    }
 }

 resource "azurerm_monitor_data_collection_rule" "linux_baseline" {
  name                = "${var.workspace_name}-dcr-linux"
  location            = var.location
  resource_group_name = var.resource_group_name

  destinations {
    log_analytics {
      name                  = "law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }

  data_sources {
    performance_counter {
      name                          = "perf"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "Processor(*)\\% Processor Time", "Processor(*)\\% Idle Time",
        "Processor(*)\\% User Time", "Memory(*)\\Available MBytes Memory",
         "Memory(*)\\% Available Memory","System(*)\\Uptime",
        "System(*)\\Load1", "System(*)\\Load5", "System(*)\\Load15", "System(*)\\Users"
      ]
    }

    syslog {
      name           = "syslog"
      streams        = ["Microsoft-Syslog"]
      facility_names = ["auth", "authpriv", "daemon", "syslog"]
      log_levels     = ["Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"]
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["law"]
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["law"]
  }
}
  
