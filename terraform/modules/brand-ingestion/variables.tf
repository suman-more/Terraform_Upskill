variable "region" {
  description = "Region details"
  type        = string
}
variable "context" {
  description = "Context details"
  type        = string
}
variable "system" {
  description = "System details"
  type        = string
}
variable "env" {
  description = "Environment details"
  type        = string
}
variable "component" {
  description = "Component details"
  type        = string
}
variable "location" {
  description = "Location details"
  type        = string
  
}
variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}
variable "app_insights_type" {
  description = "Type of Application Insights"
  type        = string
}

variable "ingestion_github_access_roles" {
  description = "Roles requierd for service principal to be accessed by github"
  type        = list(string)
}

variable "ingestion_github_federated_access" {
  description = "Federated access from github actions"
  type = list(object({
    display_name = string
    subject      = string
  }))
}
variable "app_insights_instrumentation_key" {
  description = "Instrumentation key of the shared Application Insights"
}

variable "app_insights_connection_string" {
  description = "Connection string of the shared Application Insights"
}

variable "log-analytics-workspace-id" {
  description = "Log Analytics Workspace ID"
}

# variable "github_account_name" {
#   description = "GitHub account or organization name"
#   type        = string
# }

# variable "github_branch_name" {
#   description = "Branch name in the GitHub repository"
#   type        = string
# }

# variable "github_git_url" {
#   description = "GitHub URL (e.g., https://github.com)"
#   type        = string
#   default     = "https://github.com"
# }

# variable "github_repo_name" {
#   description = "Name of the GitHub repository"
#   type        = string
# }

# variable "github_root_folder" {
#   description = "Root folder within the GitHub repository"
#   type        = string
# }

variable "genai_dev_user_ids" {
  description = "GenAI Dev User IDs"
  type        = list(string)
}