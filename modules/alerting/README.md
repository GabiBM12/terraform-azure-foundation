---

# Alerting Module (Action Group + Alert Rules)

This module provisions alerting on top of the monitoring foundation:
- **Action Group** (notification target)
- **Metric Alerts** (resource metrics like CPU) -> scoped to the VM
- **Scheduled Query (KQL) Alerts** -> scoped to the Log Analytics Workspace

---

## How alerting is connected

Azure has two main alert “engines”:

### 1) Metric Alerts (Azure Monitor Metrics)
- Scope: the resource emitting the metric (e.g. the VM)
- Example: CPU over X% for 5 minutes

### 2) Log Alerts (Scheduled Query Rules / KQL)
- Scope: the Log Analytics Workspace
- KQL runs on tables like:
  - `Syslog`
  - `Perf`
  - `AzureDiagnostics`

Both alert types can trigger the same Action Group.

---

## What this module creates

### Action Group
- Used by all alert rules as the notification/action target
- Visible in Azure:
  - Monitor -> Alerts -> Action groups

### Metric Alerts (VM scoped)
Typical:
- High CPU
- Low disk space (if using metric-based disk or if using KQL disk checks)

### Log Alerts (LAW scoped)
Typical:
- SSH failed password attempts (Syslog / auth)
- Disk low (Perf + thresholds)
- Bastion audit events (AzureDiagnostics)

---

## Wiring (envs/dev)

This module needs:
- `resource_group_name`
- `location`
- `vm_id` (for metric alerts)
- `log_analytics_workspace_id` (for KQL alerts)
- notification details (email, etc.)

---

## Validation / testing

### Confirm logs exist first (LAW -> Logs)

Syslog:
```kusto
Syslog
| where TimeGenerated > ago(30m)
| take 50