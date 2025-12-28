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

module "compute" {
  source              = "../../modules/compute"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.network.subnet_ids["private"]
  admin_username      = var.vm_admin_username
  ssh_public_key      = file(var.vm_ssh_public_key_path)
  vm_size             = var.vm_size
  tags                = var.tags

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

module "bastion" {
  source              = "../../modules/bastion"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  virtual_network_id  = module.network.vnet_id
  tags                = var.tags
}

module "monitoring" {
  source              = "../../modules/monitoring"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  workspace_name = "${var.name_prefix}-law"
}