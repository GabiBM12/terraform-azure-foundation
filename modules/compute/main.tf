resource "azurerm_network_interface" "this" {
  name = "${var.name_prefix}-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags 
 
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name = "${var.name_prefix}-vm"
  location = var.location
  resource_group_name = var.resource_group_name
  size = var.vm_size
  network_interface_ids = [azurerm_network_interface.this.id]
    admin_username = var.admin_username
    disable_password_authentication = true
    admin_ssh_key {
        username   = var.admin_username
        public_key = var.ssh_public_key
}
os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = var.tags
}