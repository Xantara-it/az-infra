resource "azurerm_public_ip" "ip" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_group" {
  for_each = { for k, v in var.security_groups : k => v }

  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = each.value.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  size                = var.size
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}