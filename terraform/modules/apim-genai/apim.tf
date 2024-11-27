resource "azurerm_api_management" "genai-apim" {
  location             = var.location
  name                 = "${local.apim_final_name}${local.apim_suffix}"
  publisher_email      = var.publisher_email
  publisher_name       = var.publisher_name
  resource_group_name  = var.resource_group_name
  sku_name             = local.apim_sku
  # virtual_network_type = var.virtual_network_type
  # public_ip_address_id = azurerm_public_ip.apim-public-ip.id
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
  # virtual_network_configuration {
  #   subnet_id = azurerm_subnet.ApimSubnet.id

  }


#   # lifecycle {
#   #   ignore_changes = [
#   #     hostname_configuration
#   #   ]
#   }
#   # depends_on = [
#   #   azurerm_subnet.AoiSubnet,
#   #   azurerm_log_analytics_workspace.log-analytics-workspace,
#   #   azurerm_network_security_group.apim_nsg
#   # ]
# }


resource "azurerm_monitor_diagnostic_setting" "apim-diagnostic" {
  name                       = "${local.apim_final_name}${local.diagnostic_suffix}"
  target_resource_id         = azurerm_api_management.genai-apim.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics-workspace.id
  log_analytics_destination_type = "Dedicated"
  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    enabled  = true
    category = "AllMetrics"
  }
  depends_on = [azurerm_log_analytics_workspace.log-analytics-workspace, azurerm_api_management.genai-apim]
}

resource "azurerm_api_management_logger" "apim-logger" {
  name                = "apim-appinsightlogger"
  api_management_name = azurerm_api_management.genai-apim.name
  resource_group_name = azurerm_api_management.genai-apim.resource_group_name

  application_insights {
    instrumentation_key = azurerm_application_insights.app-insights.instrumentation_key
  }
  depends_on = [azurerm_api_management.genai-apim, azurerm_application_insights.app-insights,azurerm_monitor_diagnostic_setting.apim-diagnostic]
}

resource "azurerm_api_management_diagnostic" "api-management-diagnostics" {
  api_management_logger_id = azurerm_api_management_logger.apim-logger.id
  api_management_name      = azurerm_api_management.genai-apim.name
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_api_management.genai-apim.resource_group_name
  sampling_percentage       = 100
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"

  depends_on = [
    azurerm_api_management_logger.apim-logger,
  ]
}

resource "azurerm_api_management_named_value" "logger-named-value" {
  api_management_name = azurerm_api_management.genai-apim.name
  display_name        = "appinsight-logger-name"
  name                = "appinsight-logger-name"
  resource_group_name = azurerm_api_management.genai-apim.resource_group_name
  secret              = true
  value = azurerm_api_management_logger.apim-logger.name
}

resource "azurerm_api_management_named_value" "logger-id-named-value" {
  api_management_name = azurerm_api_management.genai-apim.name
  resource_group_name = azurerm_api_management.genai-apim.resource_group_name
  display_name        = "${azurerm_api_management.genai-apim.name}-${azurerm_api_management_logger.apim-logger.name}-id"
  name                = "${azurerm_api_management.genai-apim.name}-${azurerm_api_management_logger.apim-logger.name}-id"
  value = azurerm_api_management_logger.apim-logger.id
  depends_on = [azurerm_api_management_logger.apim-logger,azurerm_api_management.genai-apim]
}


data "azuread_client_config" "current" {}



