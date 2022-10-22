terraform {
  required_version = ">=1.2.5"
}

terraform {
  backend "azurerm" {
    #resource_group_name  = "tamopstfstates"
    #storage_account_name = "tamopstfkhido"
    #container_name       = "tfstatedevops"
    #key                  = "terraformgithubexample.tfstate"
  }
}

provider "azuread" {}

provider "azurerm" {
   features {}
}


data "azuread_domains" "aad_domains" {
  only_default = true
}

resource "azuread_group" "AADG_Cloud_Admins" {
  display_name = "Cloud_Admin Dptment"
  security_enabled = true
  }
module "aad-user-cloud-admin" {
  source      = "./modules/aad-user-cloud-admin"
  for_each    = toset(var.userlist-cloudadmin)
  username    = each.value
  password    = var.password
  domain_name = data.azuread_domains.aad_domains.domains[0].domain_name
}
resource "azuread_group_member" "ADG_Cloud_Administrator" {  
  for_each =   { for u in module.aad-user-cloud-admin : u.upn => u if u.job_title == "Cloud Administrator" }  
  group_object_id  = azuread_group.AADG_Cloud_Admins.id
  member_object_id = each.value.object_id  
}



resource "azuread_group" "AADG_Sys_Admins" {
  display_name = "System_Admin Dptment"
  security_enabled = true
}
module "aad-user-sys-admin" {
  source      = "./modules/aad-user-sys-admin"
  for_each    = toset(var.userlist-sysadmin)
  username    = each.value
  password    = var.password
  domain_name = data.azuread_domains.aad_domains.domains[0].domain_name
}
resource "azuread_group_member" "ADG_sys_Administrator" {  
  for_each =   { for u in module.aad-user-sys-admin : u.upn => u if u.job_title == "System Administrator" }  
  group_object_id  = azuread_group.AADG_Sys_Admins.id
  member_object_id = each.value.object_id  
}

data "azurerm_subscription" "primary" {}
data "azurerm_subscription" "current" {}
data "azurerm_management_group" "example" {
  display_name = "az104-02-mg1"
}

resource "azurerm_role_definition" "RoleDef_Support_Request" {
  name        = "Support Request Contributor (Custom)"
  scope       = data.azurerm_subscription.primary.id
  description = "Allows to create support requests"

  permissions {
    actions     = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
       "Microsoft.Support/*"
    ]
    not_actions = []
  }

assignable_scopes = [
    "${data.azurerm_subscription.primary.id}","${data.azurerm_management_group.example.id}"
  ]
}

resource "azurerm_role_definition" "support_dash_read" {
  name        = "dashboard-${var.environment}-support"
  scope       = data.azurerm_subscription.current.id
  description = "Custom Role for viewing Dashboards"
  permissions {
    actions = [
      "Microsoft.Portal/dashboards/read",
      "Microsoft.Insights/*/read",
      "Microsoft.OperationalInsights/workspaces/search/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    azurerm_dashboard.insights-dashboard.id,
  ]
}

resource "azurerm_role_assignment" "example" {
  for_each =   { for u in module.aad-user-sys-admin : u.upn => u if u.job_title == "System Administrator" }  
  scope              = data.azurerm_subscription.primary.id
  principal_id  = each.value.object_id 
  role_definition_name = azurerm_role_definition.RoleDef_Support_Request.name                      
}

resource "azurerm_role_assignment" "example_cloud" {
  for_each =   { for u in module.aad-user-cloud-admin : u.upn => u if u.job_title == "Cloud Administrator" }  
  scope              = data.azurerm_subscription.primary.id
  principal_id  = each.value.object_id 
  role_definition_name = azurerm_role_definition.RoleDef_Support_Request.name                      
}

resource "azurerm_resource_group" "example" {
  name     = "mygroup"
  location = "East US"
}

resource "azurerm_dashboard" "insights-dashboard" {
  name                = "my-cool-dashboard"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  tags = {
    source = "terraform"
  }
  dashboard_properties = <<DASH
{
   "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "rowSpan": 2,
                        "colSpan": 3
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MarkdownPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "${var.md_content}",
                                    "subtitle": "",
                                    "title": ""
                                }
                            }
                        }
                    }
                },               
                "1": {
                    "position": {
                        "x": 5,
                        "y": 0,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/VideoPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "title": "Important Information",
                                    "subtitle": "",
                                    "src": "${var.video_link}",
                                    "autoplay": true
                                }
                            }
                        }
                    }
                },
                "2": {
                    "position": {
                        "x": 0,
                        "y": 4,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "ComponentId",
                                "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/myRG/providers/microsoft.insights/components/myWebApp"
                            }
                        ],
                        "type": "Extension/AppInsightsExtension/PartType/AppMapGalPt",
                        "settings": {},
                        "asset": {
                            "idInputName": "ComponentId",
                            "type": "ApplicationInsights"
                        }
                    }
                }              
            }
        }
    },
    "metadata": {
        "model": {
            "timeRange": {
                "value": {
                    "relative": {
                        "duration": 24,
                        "timeUnit": 1
                    }
                },
                "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
            },
            "filterLocale": {
                "value": "en-us"
            },
            "filters": {
                "value": {
                    "MsPortalFx_TimeRange": {
                        "model": {
                            "format": "utc",
                            "granularity": "auto",
                            "relative": "24h"
                        },
                        "displayCache": {
                            "name": "UTC Time",
                            "value": "Past 24 hours"
                        },
                        "filteredPartIds": [
                            "StartboardPart-UnboundPart-ae44fef5-76b8-46b0-86f0-2b3f47bad1c7"
                        ]
                    }
                }
            }
        }
    }
}
DASH
}

