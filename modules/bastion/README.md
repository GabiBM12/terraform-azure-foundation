# Bastion Module (Developer SKU)

This module deploys **Azure Bastion (Developer SKU)** to provide secure access
to private virtual machines **without public IPs**.

The Bastion Developer SKU attaches directly to a **Virtual Network** via
`virtual_network_id` and is intended for **dev/test** environments.

---

## What it Creates

- Azure Bastion Host (SKU: `Developer`)

---

## Inputs

- `name_prefix` – naming prefix for the Bastion resource
- `resource_group_name` – target resource group
- `location` – Azure region
- `virtual_network_id` – ID of the VNet to attach the Bastion Developer host to
- `tags` – common tags (optional)

---

## Outputs

- `bastion_id` – resource ID of the Bastion host

---

## Notes / Security

- This module does **not** create a Bastion subnet (`AzureBastionSubnet`), which
  is required only for Bastion Basic/Standard SKUs.
- To connect to a **private Linux VM**, the target subnet NSG must allow
  inbound TCP `22` from the Azure platform IP used by Bastion Developer.
  (This rule is implemented in the security baseline module.)

---

## Usage (Environment Root)

Example usage from `envs/dev/main.tf`:

```hcl
module "bastion" {
  source              = "../../modules/bastion"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_network_id  = module.network.vnet_id
  tags                = var.tags
}