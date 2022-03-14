# Name must be AzureBastionSubnet
resource "azurerm_subnet" "bastion" {
  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
  name                 = "AzureBastionSubnet"
  address_prefixes     = ["10.0.240.0/24"]
}

resource "azurerm_public_ip" "bastion" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = "ip-bastion"
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = "bastion"

  ip_configuration {
    name                 = "ip-bastion"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  tags = var.tags
}
