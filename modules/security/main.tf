resource "azurerm_network_security_group" "public" {
  name = "${var.name_prefix}-nsg-public"
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags 
  }
resource "azurerm_network_security_group" "private" {
  name = "${var.name_prefix}-nsg-private"
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
} 
# Optional: allow SSH to the public subnet from approved CIDRs only
resource "azurerm_network_security_rule" "public_allow_ssh" {
  count                       = length(var.allowed_ssh_source_cidrs) > 0 ? 1 : 0
  name                        = "Allow-SSH-From-Approved-CIDRs"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_ssh_source_cidrs
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public.name
}

# Optional: allow SSH to the private subnet from Azure Bastion Developer platform IP
resource "azurerm_network_security_rule" "private_allow_ssh_from_bastion_dev" {
  count                       = var.enable_bastion_developer ? 1 : 0
  name                        = "Allow-SSH-From-Bastion-Developer"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "168.63.129.16/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private.name
}
#This matches Microsoft's Bastion Developer requirement. 

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "public" {
subnet_id = var.subnet_ids["public"]
network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id = var.subnet_ids["private"]
  network_security_group_id = azurerm_network_security_group.private.id

}