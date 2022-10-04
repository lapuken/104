resource "azuread_user" "sys_user" {
  user_principal_name   = "${var.username}@${var.domain_name}"
  display_name          = var.username
  mail_nickname         = var.username
  job_title             = var.job_title 
  password              = var.password
  department            = var.department
  force_password_change = true
}
################################
output "upn" {
  description = "user principle name"
  value = azuread_user.sys_user.user_principal_name
 }

  output "dname" {
  description = "display name"
  value = azuread_user.sys_user.display_name
 }

output "department" {
  description = "department"
  value = azuread_user.sys_user.department
 }

output "job_title" {
  description = "Job Title"
  value = azuread_user.sys_user.job_title 
 }

 output "object_id" {
  description = "object_id"
  value = azuread_user.sys_user.object_id    
 }

  output "mail_nickname" {
  description = "mail_nickname"
  value = azuread_user.sys_user.mail_nickname
 }
###############################

