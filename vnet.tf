#
# Create a virtual network: 10.128.0.1 .. 10.128.15.254
#
resource "azurerm_virtual_network" "server-vn" {
  name                = "${var.name_prefix}-server-vn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [local.address_space_vnet]

  tags = var.tags
}

#
# Create subnet for VirtualMachines
#
resource "azurerm_subnet" "server-sn" {
  name                 = "${var.name_prefix}-server-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.server-vn.name
  address_prefixes     = [local.address_space_server]
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
  address_prefixes     = [local.address_space_gateway]
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
    source_address_prefix      = local.address_space_server
    destination_port_range     = "*"
    destination_address_prefix = local.address_space_server
  }

  security_rule {
    name                       = "AllowSshTrafficClient"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = local.address_space_client
    destination_port_range     = "22"
    destination_address_prefix = local.address_space_server
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
    destination_address_prefix = local.address_space_server
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

locals {
  address_space_vnet    = cidrsubnet(var.address_space, 4, 0)         # /20
  address_space_server  = cidrsubnet(local.address_space_vnet, 4, 0)  # /24
  address_space_gateway = cidrsubnet(local.address_space_vnet, 4, 15) # /24
  address_space_client  = cidrsubnet(var.address_space, 8, 16)        # /24
}
