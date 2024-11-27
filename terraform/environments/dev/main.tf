terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.0"
    }
  }

#   cloud {
#     organization = "Sitecore"
#     workspaces {
#       name = "ai-ai-dev"
#     }
#   }
}

provider "azurerm" {
  # subscription_id = "9a4d2d39-1755-4be8-8ea6-b3bf32141bf7"
  subscription_id = var.subscription
  features {}
}

provider "azuread" {
}
provider "random" {}

resource "azurerm_resource_group" "rg_ai_team" {
  name     = "rg-ia-${local.region}-${var.env}"
  location = var.location
  tags = {
    "team" : "ai-team",
    "env" : var.env
  }
 
 lifecycle {
    prevent_destroy = false
  }
}
module "genai_apim_gateway" {
  source                                = "../../modules/apim-genai"
  component                             = "genai"
  context                               = local.context
  env                                   = local.env
  location                              = local.location
  region                                = local.region
  resource_group_name                   = azurerm_resource_group.rg_ai_team.name
  system                                = local.system
  tags                                  = local.tags
  keyvault_roles                        = var.keyvault_roles
  sku                                   = var.sku
  sku_count                             = var.sku_count
  genai_dev_user_ids                    = local.genai_dev_user_ids
 
}

module "brand-ingestion" {
  source            = "../../modules/brand-ingestion"
  for_each = var.multi_regions
  component="genai"
  context=local.context
  env=local.env
  system=local.system
  resource_group_name = azurerm_resource_group.rg_ai_team.name
  
  tags = local.tags
  region                            = each.key
  location                          = each.value.region_name
  app_insights_type = var.app_insights_type
  app_insights_instrumentation_key = module.genai_apim_gateway.app_insights_instrumentation_key
  app_insights_connection_string   = module.genai_apim_gateway.app_insights_connection_string
  ingestion_github_access_roles = var.ingestion_github_access_roles
  ingestion_github_federated_access = var.ingestion_github_federated_access
  log-analytics-workspace-id = module.genai_apim_gateway.log-analytics-workspace-id
  # github_account_name = var.github_account_name
  # github_repo_name = var.github_repo_name
  # github_root_folder = var.github_root_folder
  # github_branch_name = var.github_branch_name
  genai_dev_user_ids  = local.genai_dev_user_ids
}



