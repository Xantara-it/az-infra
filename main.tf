#
# Create a resource group
#
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.name_prefix}-rg"
  tags     = var.tags
}

#
# Create a virtual network
#
resource "azurerm_virtual_network" "vn" {
  name                = "${var.name_prefix}-vn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["${var.address_space_prefix}.0.0/20"]

  #   ddos_protection_plan {
  #     id     = azurerm_network_ddos_protection_plan.ddos_protection.id
  #     enable = true
  #   }

  #   depends_on = [
  #     azurerm_network_ddos_protection_plan.ddos_protection
  #   ]

  tags = var.tags
}

#
# Create subnet for VirtualMachines
#
resource "azurerm_subnet" "sn" {
  name                 = "${var.name_prefix}-vn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
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
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["${var.address_space_prefix}.15.192/26"]
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
    source_address_prefix      = azurerm_subnet.sn.address_prefixes[0]
    destination_port_range     = "*"
    destination_address_prefix = azurerm_subnet.sn.address_prefixes[0]
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
    destination_address_prefix = azurerm_subnet.sn.address_prefixes[0]
  }

  tags = var.tags
}

#
# Link subnet to nsg
#
resource "azurerm_subnet_network_security_group_association" "sn-nsg" {
  subnet_id                 = azurerm_subnet.sn.id
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
  virtual_network_id    = azurerm_virtual_network.vn.id
  registration_enabled  = true
}

#
# Create a public IP for the VPN Gateway
#
resource "azurerm_public_ip" "ip" {
  name                = "${var.name_prefix}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#
# Create VPN Gateway
#
resource "azurerm_virtual_network_gateway" "gw" {
  name                = "${var.name_prefix}-gw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"
  generation    = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space = ["172.22.200.0/23"]
  }

  tags = var.tags
}
