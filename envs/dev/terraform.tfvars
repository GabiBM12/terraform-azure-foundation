# -------------------------------
# Environment identity
# -------------------------------

location            = "westeurope"
resource_group_name = "rg-tf-foundation-dev"
name_prefix         = "dev-foundation"


# -------------------------------
# Network configuration
# -------------------------------

vnet_address_space = [
  "10.10.0.0/16"
]

subnets = {
  public = {
    address_prefixes = ["10.10.1.0/24"]
  }

  private = {
    address_prefixes = ["10.10.2.0/24"]
  }
}
# -------------------------------
# Security configuration
# -------------------------------
allowed_ssh_source_cidrs = ["81.78.83.65/32"]

# -------------------------------
# VM configuration
# -------------------------------
vm_admin_username      = "azureuser"
vm_ssh_public_key_path = "~/.ssh/id_ed25519.pub"
vm_size                = "Standard_B1s"

#Important: Terraform sometimes won’t expand ~ reliably on all systems.
#If it errors, use the full path: /Users/<you>/.ssh/id_ed25519.pub



# -------------------------------
# Monitoring (optional overrides)
# -------------------------------
# Uncomment later if you want to override defaults
#
# log_analytics_sku           = "PerGB2018"
# log_analytics_retention_days = 30