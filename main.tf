terraform {
  required_version = ">=0.13"
}

provider "azuread" {
  version = ">=0.11.0"
}

provider "azurerm" {
   features {}
}

data "azuread_domains" "aad_domains" {
  only_default = true
}

module "aad-user-cloud-admin" {
  source      = "./modules/aad-user-cloud-admin"
  for_each    = toset(var.userlist)
  username    = each.value
  password    = var.password
  domain_name = data.azuread_domains.aad_domains.domains[0].domain_name

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

data "azurerm_subscription" "current" {}

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

