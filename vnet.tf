#
# Create a virtual network: 10.128.0.1 .. 10.128.15.254
#
resource "azurerm_virtual_network" "server-vn" {
  name                = "${var.name_prefix}-server-vn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["${var.address_space_prefix}.0.0/20"]

  tags = var.tags
}

resource "azurerm_virtual_network" "client-vn" {
  name                = "${var.name_prefix}-client-vn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["${var.address_space_prefix}.16.0/24"]

  tags = var.tags
}

#
# Create subnet for VirtualMachines
#
resource "azurerm_subnet" "server-sn" {
  name                 = "${var.name_prefix}-server-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.server-vn.name
  address_prefixes     = ["${var.address_space_prefix}.0.0/24"]
}

#
# Create a gateway subnet
#
# N.B.: name is fixed.
#
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.server-vn.name
  address_prefixes     = ["${var.address_space_prefix}.15.0/24"]
}

resource "azurerm_subnet" "client-sn" {
  name                 = "${var.name_prefix}-client-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.client-vn.name
  address_prefixes     = ["${var.address_space_prefix}.16.0/24"]
}

#
# Create NSG for subnet
#
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name_prefix}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "AllowTrafficWithinSubnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = azurerm_subnet.server-sn.address_prefixes[0]
    destination_port_range     = "*"
    destination_address_prefix = azurerm_subnet.server-sn.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowSshTrafficClient"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = azurerm_subnet.client-sn.address_prefixes[0]
    destination_port_range     = "22"
    destination_address_prefix = azurerm_subnet.server-sn.address_prefixes[0]
  }

  security_rule {
    name                       = "DenyAll"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = azurerm_subnet.server-sn.address_prefixes[0]
  }

  tags = var.tags
}

#
# Link subnet to nsg
#
resource "azurerm_subnet_network_security_group_association" "sn-nsg" {
  subnet_id                 = azurerm_subnet.server-sn.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#
# Create private DNS zone
#
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "infra.xantara-it.nl"
  resource_group_name = azurerm_resource_group.rg.name
}

#
# Link private DNS to vnet
#
resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  name                  = "${var.name_prefix}-dns"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.server-vn.id
  registration_enabled  = true
}
