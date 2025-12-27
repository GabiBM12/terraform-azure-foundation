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
module "security" {
  source              = "../../modules/security"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  subnet_ids = module.network.subnet_ids

  allowed_ssh_source_cidrs = var.allowed_ssh_source_cidrs
  tags                     = var.tags
}
module "monitoring" {
  source              = "../../modules/monitoring"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  workspace_name = "${var.name_prefix}-law"
}