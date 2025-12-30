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
  dcr_id              = module.monitoring.linux_dcr_id
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
  bastion_id          = module.bastion.bastion_id
  vm_id               = module.compute.vm_id

  workspace_name = "${var.name_prefix}-law"
}
module "alerting" {
  source              = "../../modules/alerting"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  email_address = var.alert_email

  vm_id                      = module.compute.vm_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  # optional overrides (keep defaults if you want)
  cpu_threshold_pct       = 80
  disk_free_threshold_pct = 15
  computer_name_contains  = "dev-foundation"
}