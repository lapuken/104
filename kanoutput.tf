 output "azurerm_resource_group_example_id" {
     description =  "azurerm_resource_group.example.id" 
     value = azurerm_resource_group.example.id
 }
output "list_details_of_Cloud_Admins" {
    value = [for s in var.userlist-cloudadmin : module.aad-user-cloud-admin[s] ]
}
output "list_details_of_Sys_identities" {
    value = [for s in var.userlist-sysadmin : module.aad-user-sys-admin[s] ]
}
 output "currenti_subscription" {
  description = "current subscription"
  value = data.azurerm_subscription.current
 }
output "Subscription_display_name" {
  description = "current subscription display_name"
  value = data.azurerm_subscription.current.display_name
 }

output "display_name" {
  value = data.azurerm_management_group.example.display_name
}

output "role_definition_supportRequest" {
    description = "Role Definition Support Request"
    value = azurerm_role_definition.RoleDef_Support_Request
}

output "role_assignment_supportRequest" {
    description = "role_assignment_supportRequest"
    value = azurerm_role_assignment.example
}
