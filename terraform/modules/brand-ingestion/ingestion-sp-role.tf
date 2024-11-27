#Co-ordinate with dev to provide terraform SP Azure AD access before running below. Source https://registry.terraform
# .io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration#method-1-api-roles-recommended-for-service-principals
data "azurerm_subscription" "current" {}
resource "azuread_application" "github_to_ingest_application_registration" {
  display_name = "${local.github_access_sp_final_name}${local.github_access_sp_suffix}"
  owners           = [data.azuread_client_config.current.object_id]
}

#Create service principal for access to apim from github
resource "azuread_service_principal" "ingest_sp" {
  client_id = azuread_application.github_to_ingest_application_registration.client_id
  depends_on = [azuread_application.github_to_ingest_application_registration]
}

resource "azurerm_role_assignment" "ingest_sp_role" {
  for_each = toset(var.ingestion_github_access_roles)
  principal_id = azuread_service_principal.ingest_sp.object_id
  role_definition_name = each.value
  scope = data.azurerm_subscription.current.id
  depends_on = [azurerm_linux_function_app.function_app, azuread_service_principal.ingest_sp]
}
resource "azuread_application_federated_identity_credential" "ingestion_github_federated_access" {
  for_each = { for idx, val in var.ingestion_github_federated_access : idx => val }
  application_id = azuread_application.github_to_ingest_application_registration.id
  audiences      = ["api://AzureADTokenExchange"]
  display_name = each.value.display_name
  issuer         = "https://token.actions.githubusercontent.com"
  subject      = each.value.subject
}