# Terraform Azure Foundation

This repository defines a **production-grade Azure foundation** using
**Terraform**, designed to reflect real-world infrastructure-as-code
practices used by professional cloud engineering teams.

The project focuses on **clarity, safety, and lifecycle-driven design**,
with explicit environment separation and a promotion-based workflow
from development to production.

---

## Objectives

- Provide a reusable Azure foundation (network, monitoring, security, compute)
- Enforce strict **environment isolation** (dev / stage / prod)
- Use **remote state** and explicit provider configuration
- Promote infrastructure through environments without duplication
- Remain **CI/CD-ready** and auditable

---

## Core Design Principles

- **Single source of truth** per environment
- **Modules define infrastructure**, environments define deployment context
- **All changes originate in dev**
- **Stage and prod receive only promoted, validated code**
- Documentation evolves with the infrastructure lifecycle

---

## Repository Structure

```text
.
├── envs/                         # Terraform root modules (environments)
│   ├── dev/
│   │   ├── backend.tf            # Remote state configuration
│   │   ├── providers.tf          # Azure provider & subscription
│   │   ├── main.tf               # Module wiring
│   │   ├── variables.tf          # Environment inputs
│   │   ├── terraform.tfvars      # Environment values
│   │   └── README.md
│   ├── stage/
│   │   └── README.md             # Scaffolded, promoted later
│   └── prod/
│       └── README.md             # Scaffolded, promoted later
│
├── modules/                      # Reusable, environment-agnostic modules
│   ├── resource-group/
│   ├── network/
│   ├── monitoring/
│   ├── security/
│   ├── compute/
│   └── README.md
│
└── README.md                     # Root documentation (this file)

Environments

Each environment is a separate Terraform root module with:
	•	its own state file
	•	its own provider configuration
	•	the ability to target a different Azure subscription

Terraform commands are always executed from within an environment directory:
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
 
    At early stages of the project, only dev is implemented.
stage and prod are intentionally scaffolded to reflect a
promotion-based lifecycle.

Modules

Modules define what infrastructure is created, not where it is deployed.

Modules:
	•	contain no provider or backend configuration
	•	are reusable across all environments
	•	are parameterised via inputs and outputs
	•	evolve independently of environments

Authentication

Terraform authenticates using the Azure CLI.
Each environment explicitly defines its target Azure subscription to ensure
deterministic and safe deployments.

Infrastructure Lifecycle & Promotion

All infrastructure changes follow a strict lifecycle:
	1.	Develop and apply changes in envs/dev
	2.	Validate behaviour and stability
	3.	Promote the same configuration to stage
	4.	Promote to prod once validated

This avoids duplication and ensures predictable, auditable changes.

Status

This repository is under active development and is intentionally structured
as a long-term, extensible Azure foundation.
