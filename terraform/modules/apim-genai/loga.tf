resource "azurerm_log_analytics_workspace" "log-analytics-workspace" {
  location            = var.location
  name                = "${local.loga_final_name}${local.loga_suffix}"
  resource_group_name = var.resource_group_name
  depends_on = [azurerm_key_vault.genai-keyvault]
  tags = var.tags

}

resource "azurerm_application_insights" "app-insights" {
  application_type    = "web"
  location            = azurerm_log_analytics_workspace.log-analytics-workspace.location
  name                = "${local.loga_final_name}${local.appinsight_suffix}"
  resource_group_name = azurerm_log_analytics_workspace.log-analytics-workspace.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log-analytics-workspace.id
  tags = var.tags
  depends_on = [azurerm_log_analytics_workspace.log-analytics-workspace]
}
#Add application insight key to keyvault
resource "azurerm_key_vault_secret" "app-insights-key" {
  name  = "app-insights-keyss"
  value = azurerm_application_insights.app-insights.instrumentation_key
  key_vault_id = azurerm_key_vault.genai-keyvault.id
  depends_on = [azurerm_key_vault.genai-keyvault]
}
resource "azurerm_key_vault_secret" "app-insights-connection-string" {
  name  = "app-insights-connection-stringss"
  value = azurerm_application_insights.app-insights.connection_string
  key_vault_id = azurerm_key_vault.genai-keyvault.id
  depends_on = [azurerm_key_vault.genai-keyvault]
}