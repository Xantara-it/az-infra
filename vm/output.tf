output "name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "user" {
  value = azurerm_linux_virtual_machine.vm.admin_username
}

output "ip_addr" {
  value = azurerm_public_ip.ip.ip_address
}