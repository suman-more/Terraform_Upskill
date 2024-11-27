output "log-analytics-workspace" {
  value = azurerm_log_analytics_workspace.log-analytics-workspace
}

output "app-insights" {
  value = azurerm_application_insights.app-insights
}

output "apim_name" {
  value = azurerm_api_management.genai-apim.name
}
output "app_insights_instrumentation_key" {
  value = azurerm_application_insights.app-insights.instrumentation_key
}

output "app_insights_connection_string" {
  value = azurerm_application_insights.app-insights.connection_string
}

output "log-analytics-workspace-id" {
  value = azurerm_log_analytics_workspace.log-analytics-workspace.id
}
