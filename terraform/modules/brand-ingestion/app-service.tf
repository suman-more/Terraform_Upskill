data "azuread_client_config" "cur" {}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${local.app_service_final_name}${local.app_service_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku_name            = "EP2"
  os_type             = "Linux"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "${local.function_app_final_name}${local.function_app_suffix}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.app_service_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  depends_on                 = [azurerm_storage_account.storage_account]
  tags                       = var.tags
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"   = "python"
    "WEBSITE_WEBDEPLOY_USE_SCM" = "true"
    "WEBSITE_RUN_FROM_PACKAGE"    = "1"
    "AuthenttticationSecretss" = azurerm_key_vault_secret.client_secret.id 
    # "storage_uses_managed_identity" = "true"
  }
  
  site_config {
  application_insights_connection_string = var.app_insights_connection_string
  application_insights_key = var.app_insights_instrumentation_key
  application_stack{
    python_version = "3.10"
  }
  }
   auth_settings_v2{
    auth_enabled = true
    runtime_version = "~2"
    require_authentication = true
    require_https = true
    unauthenticated_action = "RedirectToLoginPage"

    active_directory_v2 {
      client_id = azuread_application.app-registration.client_id
      client_secret_setting_name = "AuthenttticationSecretss"
      tenant_auth_endpoint = "https://login.microsoftonline.com/${data.azuread_client_config.cur.tenant_id}/v2.0"
      allowed_applications = [azuread_application.app-registration.client_id, data.azuread_service_principal.service_principal.client_id]
  }
  login{}
  }
  lifecycle {
    ignore_changes = [app_settings]
  }
}

data "azurerm_function_app_host_keys" "example" {
  name                = azurerm_linux_function_app.function_app.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "function_key" {
  name         = "function-keys"
  value        = data.azurerm_function_app_host_keys.example.default_function_key
  key_vault_id = azurerm_key_vault.genai-keyvaultt.id
  depends_on   = [azurerm_key_vault.genai-keyvaultt]
}

resource "azurerm_monitor_diagnostic_setting" "function_app_diagnostic" {
  name                       = "${local.function_app_final_name}${local.diagnostic_fun_app_suffix}"
  target_resource_id         = azurerm_linux_function_app.function_app.id
  log_analytics_workspace_id = var.log-analytics-workspace-id
  log_analytics_destination_type = "Dedicated"
  enabled_log {
    category_group = "AllLogs"
  }
  metric {
    enabled  = true
    category = "AllMetrics"
  }
  depends_on = [azurerm_linux_function_app.function_app]
}