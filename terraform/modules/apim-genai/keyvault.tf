#Create keyvault
resource "azurerm_key_vault" "genai-keyvault" {
  name                = "${local.keyvault_final_name}${local.keyvault_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azuread_client_config.current.tenant_id
  enable_rbac_authorization = true
  tags = var.tags
}

# resource "azurerm_role_assignment" "keyvault_admin" {
#   principal_id = data.azuread_client_config.current.object_id
#   scope        = azurerm_key_vault.genai-keyvault.id
#   role_definition_name = "Key Vault Administrator"
#   depends_on = [azurerm_key_vault.genai-keyvault]
# }
