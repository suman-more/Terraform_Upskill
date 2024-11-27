resource "azurerm_key_vault" "genai-keyvaultt" {
  name                = "${local.keyvault_final_name}${local.keyvault_suffix}"
  location= var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azuread_client_config.current.tenant_id
  enable_rbac_authorization = true
  tags                = var.tags
}