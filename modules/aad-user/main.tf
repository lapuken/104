resource "azuread_user" "user" {
  user_principal_name   = "${var.username}@${var.domain_name}"
  display_name          = var.username
  mail_nickname         = var.username
  password              = var.password
  force_password_change = true
}