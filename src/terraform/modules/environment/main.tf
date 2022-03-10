
resource "azurerm_resource_group" "env" {
  name     = "rg-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "env" {
  name                = "nsg-${var.environment}"
  location            = azurerm_resource_group.env.location
  resource_group_name = azurerm_resource_group.env.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "env" {
  name                = "sn-${var.environment}"
  resource_group_name = "rg-infra"
  virtual_network_name = "vn-infra"
  address_prefixes = [var.cidr_blocks_snet]
}

resource "azurerm_subnet_network_security_group_association" "env" {
  subnet_id                 = azurerm_subnet.env.id
  network_security_group_id = azurerm_network_security_group.env.id
}
