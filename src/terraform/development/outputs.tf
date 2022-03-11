output "admin_username" {
  value = module.environment.admin_username
}

output "admin_password" {
  value     = module.environment.admin_password
  sensitive = true
}
