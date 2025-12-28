resource "azurerm_bastion_host" "this" {
    name = "${var.name_prefix}-bastion"
    location = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id = var.virtual_network_id
  sku = "Developer"
    tags = var.tags
}
# The provider exposes a virtual_network_id field specifically for Developer Bastion hosts.
 # And Microsoft docs confirm Developer differs from other SKUs (no dedicated Bastion subnet).