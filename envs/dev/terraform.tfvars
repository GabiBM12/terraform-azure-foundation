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
# Monitoring (optional overrides)
# -------------------------------
# Uncomment later if you want to override defaults
#
# log_analytics_sku           = "PerGB2018"
# log_analytics_retention_days = 30