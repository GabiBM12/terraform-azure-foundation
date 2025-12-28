output "nsg_ids" {
  description = "NSG IDs keyed by subnet type"
  value = {
    public  = azurerm_network_security_group.public.id
    private = azurerm_network_security_group.private.id
  }
}