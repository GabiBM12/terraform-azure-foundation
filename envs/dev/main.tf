resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}
module "network" {
  source              = "../../modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  vnet_name           = "${var.name_prefix}-vnet"
  address_space       = var.vnet_address_space
  subnets             = var.subnets
}
module "monitoring" {
  source              = "../../modules/monitoring"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  workspace_name = "${var.name_prefix}-law"
}