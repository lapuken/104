resource "azuread_user" "user" {
  user_principal_name   = "${var.username}@${var.domain_name}"
  display_name          = var.username
  mail_nickname         = var.username
  job_title             = var.job_title 
  password              = var.password
  department            = var.department
  force_password_change = true
}

 output "upn" {
  description = "user principle name"
  value = azuread_user.user.user_principal_name
 }

output "department" {
  description = "department"
  value = azuread_user.user.department
 }

output "job_title" {
  description = "Job Title"
  value = azuread_user.user.job_title 
 }