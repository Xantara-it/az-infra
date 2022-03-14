# See: https://gmusumeci.medium.com/how-to-deploy-a-red-hat-enterprise-linux-rhel-vm-in-azure-using-terraform-90f3d413c783


# Create a random password
resource "random_password" "vm" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_public_ip" "vm" {
  name                = "ip-public-vm01d"
  resource_group_name = azurerm_resource_group.env.name
  location            = azurerm_resource_group.env.location
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "vm" {
  name                = "nic-${var.linux_vm_name}"
  location            = azurerm_resource_group.env.location
  resource_group_name = azurerm_resource_group.env.name

  ip_configuration {
    name                          = "public"
    public_ip_address_id          = azurerm_public_ip.vm.id
    subnet_id                     = azurerm_subnet.env.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  location              = azurerm_resource_group.env.location
  resource_group_name   = azurerm_resource_group.env.name
  name                  = var.linux_vm_name
  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = var.linux_vm_size
  source_image_reference {
    offer     = var.linux_vm_image_offer
    publisher = var.linux_vm_image_publisher
    sku       = var.linux_vm_image_sku
    version   = var.linux_vm_image_version
  }
  os_disk {
    name                 = "root-${var.linux_vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  computer_name  = var.linux_vm_name
  admin_username = var.linux_admin_username
  admin_password = random_password.vm.result
  # custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  disable_password_authentication = false

  tags = {
    environment = var.environment
  }
}
