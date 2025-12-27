# Dev Environment

The **dev environment** is used for active development and validation of
infrastructure changes.

All new infrastructure:
- is introduced here first
- can be modified or recreated
- is validated before promotion to higher environments

---

## Purpose

- Develop and test Terraform modules
- Validate infrastructure design
- Iterate safely without impacting stable environments

---

## Usage

Terraform commands must be executed from this directory:

```bash
cd envs/dev
terraform init
terraform plan
terraform apply