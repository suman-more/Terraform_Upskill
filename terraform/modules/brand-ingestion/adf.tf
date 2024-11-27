resource "azurerm_data_factory" "data_factory" {
  name                = "${local.adf_final_name}${local.adf_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  identity {
    type              = "SystemAssigned"
  }
  # github_configuration {
  #   account_name      = var.github_account_name
  #   repository_name   = var.github_repo_name
  #   root_folder       = var.github_root_folder
  #   branch_name = var.github_branch_name
  # }
  
}

# resource "azurerm_data_factory_integration_runtime_azure" "integration_runtime" {
#   name              = "${local.ir_final_name}${local.ir_suffix}"
#   data_factory_id   = azurerm_data_factory.data_factory.id
#   location          = var.location
# }

data "azuread_service_principal" "service_principal" {
  object_id  = azurerm_data_factory.data_factory.identity[0].principal_id
  depends_on = [azurerm_data_factory.data_factory]
}

# resource "azurerm_data_factory_linked_service_key_vault" "key_vault" {
#   for_each          = var.multi_regions
#   name              = "Brandingestionlskeyvault"
#   data_factory_id   = azurerm_data_factory.data_factory[each.key].id
#   key_vault_id      = azurerm_key_vault.genai-keyvault[each.key].id
# }

# resource "azurerm_data_factory_linked_service_azure_function" "data_factory" {
#   for_each          = var.multi_regions
#   name              = "Brandingestionls"
#   data_factory_id   = azurerm_data_factory.data_factory[each.key].id
#   integration_runtime_name = azurerm_data_factory_integration_runtime_azure.integration_runtime[each.key].name
#   url               = "https://${azurerm_linux_function_app.function_app[each.key].name}.azurewebsites.net"
#   key_vault_key {
#     linked_service_name = azurerm_data_factory_linked_service_key_vault.key_vault[each.key].name
#     secret_name         = azurerm_key_vault_secret.function_key[each.key].name
#   }
# }

resource "azurerm_key_vault_access_policy" "data_factory_key_vault_access" {
  key_vault_id       = azurerm_key_vault.genai-keyvaultt.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_data_factory.data_factory.identity[0].principal_id
  secret_permissions = [ "Get", "List"]
}

resource "azurerm_role_assignment" "datafactory_key_vault_secrets_user" {
  scope                = azurerm_key_vault.genai-keyvaultt.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
  depends_on           = [ azurerm_key_vault.genai-keyvaultt ]
}

data "azurerm_client_config" "current" {}