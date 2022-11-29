#
# Create a resource group
#
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.name_prefix}-rg"
  tags     = var.tags
}

module "vm" {
  source = "./vm"
  for_each = {
    demo1 = { subnet = azurerm_subnet.server-sn }
  }

  name           = each.key
  resource_group = azurerm_resource_group.rg
  security_groups = [
    azurerm_network_security_group.nsg
  ]
  subnet = each.value.subnet
}
