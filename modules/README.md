# Terraform Modules

This directory contains **reusable, environment-agnostic Terraform modules**
used to build the Azure foundation.

Modules define **what infrastructure is created**.
Environments define **where and how it is deployed**.

---

## Design Principles

All modules in this repository follow these rules:

- No provider configuration
- No backend configuration
- No hard-coded environment values
- Fully parameterised via variables
- Reusable across all environments

---

## Available Modules

| Module | Description |
|------|------------|
| `network` | Creates the virtual network and subnets |
| `monitoring` | Creates the Log Analytics workspace |
| `compute` | Deploys compute resources |
| `bastion` | Creates a Bastion for secure conection to the Vms |
| `security`| Creates security layers for the enviroment |
---

## Resource Groups

Resource Groups are defined **at the environment level**
(e.g. in `envs/dev/main.tf`).

This allows:
- environment-specific naming
- flexible resource grouping
- clear ownership per environment

---

## Usage Pattern

Modules are consumed by environment root modules:

```hcl
module "network" {
  source = "../../modules/network"
  # inputs provided by the environment
}

Module Lifecycle

Modules evolve independently of environments:
	1.	New functionality is added to a module
	2.	The module is wired into envs/dev
	3.	Changes are validated
	4.	The same module is promoted to stage and prod