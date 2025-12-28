# Cost Notes

## Purpose

This document outlines **cost-related considerations** for the Azure Terraform Foundation platform.

The goal is not detailed FinOps analysis, but **cost awareness**, transparency, and intentional design choices—especially during early development stages.

---

## Environment Scope

At this stage, **only the dev environment is deployed**.

- Stage and prod are not yet active
- All cost considerations below apply to **development usage only**
- No high availability or scale assumptions are made

---

## Major Cost Drivers

### 1. Azure Bastion

**Cost Impact:** Medium (relative to dev workloads)

- Azure Bastion introduces a fixed hourly cost
- Used to eliminate public IP exposure and inbound SSH
- Chosen for security over cost

**Notes:**
- Bastion Developer SKU is sufficient for dev
- Bastion Standard / Premium may be required in prod
- Cost is justified as a security control, not convenience

---

### 2. Virtual Machine (Compute)

**Cost Impact:** Low–Medium (depending on size)

- Single Linux VM
- Non-HA
- No autoscaling
- Intended for development and learning

**Notes:**
- VM size should remain modest in dev
- Compute cost can be reduced by stopping the VM when not in use
- Production sizing will be revisited later

---

### 3. Managed Disks

**Cost Impact:** Low

- Standard managed OS disk
- No data disks at this stage
- No snapshots or backups yet enabled

**Notes:**
- Disk cost is predictable
- Backup and snapshot costs will be added later

---

### 4. Log Analytics Workspace

**Cost Impact:** Low (initially)

- Workspace is deployed but lightly used
- Ingestion-based pricing model
- Retention defaults apply

**Notes:**
- Cost will increase as:
  - Diagnostic settings are added
  - VM telemetry is enabled
  - Retention periods are extended
- Monitoring is considered a required platform capability

---

### 5. Networking

**Cost Impact:** Low

- Single VNet
- No NAT Gateway
- No VPN / ExpressRoute
- No traffic-heavy workloads

**Notes:**
- Most networking components are free or low-cost
- Future connectivity options may introduce additional cost

---

## Cost Management Principles

The following principles guide cost decisions:

- **Dev is not optimized for scale**
- **Security is prioritized over minimal cost**
- **Costs should be visible and explainable**
- **No “always-on” resources without justification**

---

## Cost Controls (Current)

- Single-region deployment
- No redundant resources
- No HA components
- Manual VM lifecycle control (start/stop)

---

## Future Cost Considerations

As the platform evolves, costs will increase due to:

- Stage and prod environments
- High availability patterns
- Monitoring depth (alerts, retention)
- Backup and disaster recovery
- CI/CD automation

These costs are intentionally deferred until:
- Architecture is validated
- Promotion workflows are established
- Operational needs are clearer

---

## Summary

This platform is intentionally **cost-conscious but not cost-driven**.

Current spending reflects:
- Development-stage usage
- Security-first decisions
- Monitoring as a foundational capability

Cost optimization will be addressed progressively as the platform matures.