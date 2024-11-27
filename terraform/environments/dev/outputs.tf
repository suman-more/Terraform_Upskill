output "rg_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.rg_ai_team.name
}

# output "managed_identity_application_id" {
#   value       = module.brand-ingestion.managed_identity_application_id
#   description = "The Application IDs (client IDs) for the managed identities from the brand-ingestion module."
# }

