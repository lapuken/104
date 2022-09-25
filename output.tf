

 output "azurerm_resource_group_example_id" {
     description =  "azurerm_resource_group.example.id" 
     value = azurerm_resource_group.example.id
 }

output "list_details_of_AAD_identities" {
    value = [for s in var.userlist : module.aad-user-cloud-admin[s] ]
}



