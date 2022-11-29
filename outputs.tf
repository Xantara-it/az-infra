output "subnet_server_prefix" {
  value = azurerm_subnet.server-sn.address_prefixes
}

output "subnet_gateway_prefix" {
  value = azurerm_subnet.gateway.address_prefixes
}

output "vpn_public_ip" {
  value = azurerm_public_ip.ip.ip_address
}

output "vms" {
  value = module.vm
}
