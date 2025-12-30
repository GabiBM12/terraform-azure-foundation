# Architecture Decisions

## Purpose

This document records the key **architecture and design decisions** made while building the Azure Terraform Foundation platform.

The goal is to make decisions **explicit, reviewable, and repeatable**, rather than implicit or hidden in code.

---

## 1. Environment-First Approach

**Decision:**  
Start with a fully functional **dev environment** before deploying stage or prod.

**Rationale:**  
- Allows rapid iteration without risk
- Enables validation of module design and state isolation
- Prevents premature complexity in stage/prod

**Trade-offs:**  
- Stage and prod are delayed
- Requires discipline to promote changes later

---

## 2. Modular Terraform Design

**Decision:**  
Split infrastructure into focused Terraform modules:
- `network`
- `bastion`
- `compute`
- `monitoring`

**Rationale:**  
- Improves reusability across environments
- Enforces separation of concerns
- Simplifies future expansion (stage/prod, new regions)

**Trade-offs:**  
- More upfront structure
- Requires explicit wiring via outputs/inputs

---

## 3. Azure Bastion for Access

**Decision:**  
Use **Azure Bastion** instead of public IPs for VM access.

**Rationale:**  
- Eliminates public SSH exposure
- Aligns with enterprise security practices
- Reduces attack surface
- No need to manage inbound SSH rules from the internet

**Trade-offs:**  
- Additional cost compared to public IP
- Browser-based SSH experience can be slower
- Bastion SKU limitations (Developer vs Standard)

---

## 4. No Public IP on Virtual Machines

**Decision:**  
Do not assign public IPs to compute resources.

**Rationale:**  
- Forces all access through controlled entry points
- Prevents accidental exposure
- Encourages private networking patterns

**Trade-offs:**  
- Requires Bastion or jump-host access
- Slightly higher operational complexity

---

## 5. SSH Key-Based Authentication Only

**Decision:**  
Disable password authentication and use **SSH keys only**.

**Rationale:**  
- Prevents brute-force attacks
- Aligns with modern Linux security practices
- Simplifies credential management

**Trade-offs:**  
- Requires key management discipline
- Initial setup is more complex for beginners

---

## 6. Ubuntu 22.04 LTS as Base Image

**Decision:**  
Use **Ubuntu 22.04 LTS (Jammy Jellyfish)** for Linux VMs.

**Rationale:**  
- Long-term support
- Wide ecosystem compatibility
- Strong Azure support
- Familiarity for operations and troubleshooting

**Trade-offs:**  
- Slightly newer than some enterprise defaults
- Requires attention to Azure image SKU formats

---

## 7. Centralized Monitoring via Log Analytics Workspace

**Decision:**  
Deploy a **Log Analytics Workspace (LAW)** as a first-class platform component.

**Rationale:**  
- Central point for logs and metrics
- Required for Azure Monitor Agent and VM Insights
- Scales naturally to stage and prod
- Encourages observability from day one

**Trade-offs:**  
- Ingestion and retention costs
- Requires additional configuration (diagnostic settings, agents)

---

## 8. Monitoring as a Module

**Decision:**  
Implement monitoring as a dedicated Terraform module.

**Rationale:**  
- Avoids scattering monitoring logic across environments
- Enables consistent observability standards
- Simplifies future expansion (alerts, DCRs, insights)

**Trade-offs:**  
- Requires passing resource IDs between modules
- Slightly more complex module interface

---
##  8.1 Alerting Decisions

- **Action Groups** are used to decouple alert rules from notification delivery.
- **Metric alerts** are used for low-latency resource health signals.
- **Log alerts** are used for flexible, query-based operational and security detection.
- Alerting is implemented in a dedicated Terraform module to keep monitoring
  ingestion and alerting concerns separate.

## 9. Remote Terraform State

**Decision:**  
Use a **remote backend** for Terraform state.

**Rationale:**  
- Prevents state loss
- Enables team collaboration
- Enforces state isolation per environment
- Required for production-grade workflows

**Trade-offs:**  
- Requires backend bootstrap
- Adds dependency on Azure Storage

---

## 10. Delayed Stage and Prod Environments

**Decision:**  
Delay deployment of stage and prod until dev is stable.

**Rationale:**  
- Prevents propagating design mistakes
- Allows monitoring and access patterns to be validated
- Encourages promotion-based workflows

**Trade-offs:**  
- Slower path to multi-environment parity
- Requires conscious promotion later

---

## 11. Incremental Maturity Model

**Decision:**  
Build the platform incrementally rather than upfront.

**Rationale:**  
- Reflects real-world engineering workflows
- Keeps complexity manageable
- Allows learning-driven evolution

**Trade-offs:**  
- Not all best practices are present on day one
- Requires periodic refactoring

---

## Summary

These decisions prioritize:
- Security over convenience
- Clarity over speed
- Evolution over premature optimization

The platform is intentionally designed to grow in maturity without requiring re-architecture.