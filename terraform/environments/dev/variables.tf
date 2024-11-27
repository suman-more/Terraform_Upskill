variable "location" {
  type        = string
  description = "The location in Azure"
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group for the Terraform state"
  default     = "rg-ai-team"
}

variable "env" {
  type        = string
  description = "The environment of infra for the Terraform state"
  default     = "dev"
}

variable "subscription" {
  type        = string
  description = "subscription id"
  default     = "89dfb358-f764-4940-aa9f-68d7ab4b5f6e"
}

variable "multi_regions" {
  description = "Configuration for resources across different regions"
  type = map(object({
    region_name = string
  }))
  default = {
    euw = {
      region_name = "West Europe"
    }
    # eus = {
    #   region_name = "East US 2"
    # }
  }
}

variable "app_insights_type" {
  description = "Type of Application Insights"
  type        = string
  default     = "web"
}

# variable "github_access_roles" is used to define the roles for service principal used by github for apiops
variable "ingestion_github_access_roles" {
  description = "Roles requierd for service principal to be accessed by github"
  type        = list(string)
  default = [
    "Contributor",
    "Storage Blob Data Contributor"
  ]
}

# Federated access from github actions subject mapping. This is used only in github actions. https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure
variable "ingestion_github_federated_access" {
  description = "Federated access from github actions"
  type = list(object({
    display_name = string
    subject      = string
  }))
  default = [
    { display_name = "githubtoingestdevenvironmentSumanMore", subject = "repo:SumanMore/Terraform-demo:environment:dev" },
    # { display_name : "githubtoingest", subject : "repo:Sitecore-PD/sitecore.ai.ingest:ref:refs/heads/master" },
    # { display_name : "githubtoingestforpullrequest", subject : "repo:Sitecore-PD/sitecore.ai.ingest:pull_request" },
    # { display_name : "githubtoingestdevenvironment", subject : "repo:Sitecore-PD/sitecore.ai.system:environment:dev" },
    # { display_name : "githubtoingestqaenvironment", subject : "repo:Sitecore-PD/sitecore.ai.system:environment:qa" },
    # { display_name : "githubtoingestprodenvironment", subject : "repo:Sitecore-PD/sitecore.ai.system:environment:stg" },
  ]
}

# variable "github_account_name" {
#   description = "GitHub account or organization name"
#   type        = string
#   # default     = "Sitecore-PD"
#   default = "SumanMore"
# }

# variable "github_branch_name" {
#   description = "Branch name in the GitHub repository"
#   type        = string
#   # default     = "develop"
#   default = "suman/multi-region"
# }

# # variable "github_git_url" {
# #   description = "GitHub URL (e.g., https://github.com)"
# #   type        = string
# #   default     = "https://github.com"
# # }

# variable "github_repo_name" {
#   description = "Name of the GitHub repository"
#   type        = string
#   # default     = "sitecore.ai.ingest"
#   default = "Terraform-demo"
# }

# variable "github_root_folder" {
#   description = "Root folder within the GitHub repository"
#   type        = string
#   default     = "/"
# }

#Roles for keyvault access
variable "keyvault_roles" {
  description = "Roles requierd for keyvault"
  type        = list(string)
  default = [
    "Key Vault Certificate User",
    "Key Vault Crypto User",
    "Key Vault Reader",
    "Key Vault Secrets User",

  ]
}

#APIM Related variables for environment specific
variable "sku" {
  description = "The pricing tier of this API Management service"
  default     = "Developer"
  type        = string
  validation {
    condition     = contains(["Consumption", "Developer", "Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku must be one of the following: Developer, Standard, Premium."
  }
}

variable "sku_count" {
  description = "The instance size of this API Management service."
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2], var.sku_count)
    error_message = "The sku_count must be one of the following: 1, 2."
  }
}