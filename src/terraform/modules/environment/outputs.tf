output "environment" {
  value = var.environment
}

output "cidr_blocks_snet" {
  value = var.cidr_blocks_snet
}

output "admin_username" {
  value = var.linux_admin_username
}

output "admin_password" {
  value     = random_password.vm.result
  sensitive = true
}
