data "azuread_client_config" "current" {}
resource "azuread_application" "app-registration" {
  display_name = "brand-ingestion-app-registration"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "app-reg-client-secret" {
  display_name   = "ClientSecretss"
  application_id =  "/applications/${azuread_application.app-registration.object_id}"
}

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "AuthenttticationSecretss"
  value        = azuread_application_password.app-reg-client-secret.value
  key_vault_id = azurerm_key_vault.genai-keyvaultt.id
  depends_on   = [ azurerm_key_vault.genai-keyvaultt ]
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id = azurerm_key_vault.genai-keyvaultt.id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = data.azuread_client_config.current.object_id
  secret_permissions = ["Set", "Get", "Delete", "List"]
  depends_on = [ azurerm_key_vault.genai-keyvaultt]
}

resource "azurerm_role_assignment" "keyvault_admin" {
  principal_id = data.azuread_client_config.current.object_id
  scope        = azurerm_key_vault.genai-keyvaultt.id
  role_definition_name = "Key Vault Administrator"
  depends_on = [azurerm_key_vault.genai-keyvaultt]
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.genai-keyvaultt.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_client_config.current.object_id
  depends_on           = [ azurerm_key_vault.genai-keyvaultt ]
}

resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = azurerm_key_vault.genai-keyvaultt.id
  role_definition_name = "Key Vault Reader"
  principal_id         = data.azuread_client_config.current.object_id
  depends_on           = [ azurerm_key_vault.genai-keyvaultt ]
}