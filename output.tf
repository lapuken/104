

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



