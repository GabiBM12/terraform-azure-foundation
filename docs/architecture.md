# Architecture Overview

## Purpose

This document describes the current **Azure Terraform Foundation architecture** as implemented in the **development (dev) environment**.

The goal of this architecture is to provide a **secure, modular, and production-aligned baseline** that can be promoted to stage and prod environments once validated.

---

## Environments

At this stage, only the **dev environment** is actively deployed.

Directory structure:

envs/
├── dev/
├── stage/
└── prod/

- `dev` is used for active development and validation
- `stage` and `prod` exist as placeholders and are **not yet deployed**
- All infrastructure is provisioned using **Terraform modules**

---

## High-Level Architecture (Dev)

The dev environment consists of:

- One Azure Resource Group
- One Virtual Network (VNet)
- Segregated subnets for compute and Bastion
- Azure Bastion for secure access
- A Linux virtual machine in a private subnet
- Centralized monitoring via Log Analytics Workspace

---

## Networking

### Virtual Network (VNet)

- A single VNet is deployed for the dev environment
- Address space is defined per environment via variables
- The VNet is created via the `network` module

### Subnets

The VNet contains the following subnets:

1. **Private Subnet**
   - Hosts the Linux virtual machine
   - No public IPs assigned
   - Protected by a Network Security Group (NSG)

---

## Access Model (Security First)

### Azure Bastion

- Azure Bastion is deployed via the `bastion` module
- Bastion provides **SSH access without exposing public IPs**
- Access is browser-based via the Azure Portal
- Bastion connects to the VM over the private network

### SSH Access

- SSH access is **key-based only**
- Password authentication is disabled
- The VM does not have a public IP
- Bastion is the **only entry point**

This mirrors common enterprise security practices.

---

## Compute

### Linux Virtual Machine

- Deployed via the `compute` module
- Runs **Ubuntu 22.04 LTS**
- Placed in the private subnet
- Uses managed OS disks
- VM agent is enabled (required for monitoring and extensions)

### Image Reference

The VM uses the following image reference:

```hcl
publisher = "Canonical"
offer     = "0001-com-ubuntu-server-jammy"
sku       = "22_04-lts"
version   = "latest"
Monitoring

Log Analytics Workspace
	•	A centralized Log Analytics Workspace (LAW) is deployed via the monitoring module
	•	The workspace is intended to collect:
	•	Platform logs
	•	Metrics
	•	VM telemetry (via Azure Monitor Agent in later steps)

At this stage:
	-	The LAW is deployed and available
	-	Azure Monitor Agent (AMA) installed via VM extension
	-   Central Log Analytics Workspace
    - 	Data Collection Rule (Linux baseline):
    - 	Performance counters (CPU, Memory, Disk)
    -  	Linux Syslog (auth, daemon, syslog)
    - 	Bastion diagnostic logs forwarded to Log Analytics
    - 	DCR associated at VM level (separation of concerns)

⚠️ Note: After initial deployment, VM restart may be required
for AMA to fully apply DCR configuration.
 
 
 
  Alerting Architecture

Alerting is built on Azure Monitor and consumes data already collected in Log Analytics
and Azure Monitor Metrics.

- **Metric alerts** are scoped directly to the Virtual Machine and used for
  infrastructure health signals (e.g. CPU usage).
- **Log alerts (KQL)** are scoped to the Log Analytics Workspace and used for
  operational and security signals (e.g. SSH failures, disk usage).
- A shared **Action Group** is used as the notification target for all alerts.

This separation ensures correct evaluation context and aligns with Azure best practices.
    
    Terraform Design

Modular Structure

Infrastructure is split into reusable modules:

modules/
├── network/
├── bastion/
├── compute/
├── security/
└── monitoring/

Each module:
	•	Has a single responsibility
	•	Exposes outputs for composition
	•	Is environment-agnostic

Environment Composition

The envs/dev folder:
	•	Composes modules together
	•	Defines environment-specific values
	•	Uses a remote backend for Terraform state

State Management
	•	Terraform state is stored remotely in Azure Storage
	•	Each environment has an isolated state
	•	This prevents cross-environment interference

Current Scope and Limitations

This architecture intentionally focuses on:
	•	Single-region deployment
	•	Single VM (non-HA)
	•	Development-grade cost profile

Out of scope (for now):
	•	High availability
	•	Autoscaling
	•	Disaster recovery
	•	CI/CD automation

These will be introduced gradually as the platform matures.
Next Planned Enhancements
	•	Diagnostic settings for Bastion and networking resources
	•	Azure Monitor Agent (AMA) for VM telemetry
	•	Data Collection Rules (DCR)
	•	Stage environment deployment
	•	Policy enforcement and tagging standards


Summary

This architecture establishes a secure, modular Azure foundation with:
	•	No public VM exposure
	•	Centralized monitoring
	•	Clear separation of concerns
	•	A clean promotion path to stage and prod

It is designed to evolve incrementally without requiring rework.
