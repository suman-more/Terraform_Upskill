locals {
  # vnet_name_length = 44
  # vnet_suffix      = "-vnet"
  prefix           = "${var.region}-${var.context}-${var.system}-${var.env}"

  # vnet_prefix     = "${local.prefix}-${var.component}"
  # vnet_final_name = length(local.vnet_prefix) > local.vnet_name_length - length(local.vnet_suffix) ? substr(local.vnet_prefix, 0, local.vnet_name_length - length(local.vnet_suffix)) : local.vnet_prefix

  loga_name_length  = 44
  loga_suffix       = "-logad"
  appinsight_suffix = "-appinsightd"
  loga_prefix       = "${local.prefix}-${var.component}"
  loga_final_name   = length(local.loga_prefix) > local.loga_name_length - length(local.loga_suffix) ? substr(local.loga_prefix, 0, local.loga_name_length - length(local.loga_suffix)) : local.loga_prefix

  
  apim_name_length = 44
  apim_suffix      = "-apimtest"
  apim_prefix      = "${local.prefix}-${var.component}"
  apim_final_name  = length(local.apim_prefix) > local.apim_name_length - length(local.apim_suffix) ? substr(local.apim_prefix, 0, local.apim_name_length - length(local.apim_suffix)) : local.apim_prefix
  apim_sku         = "${var.sku}_${var.sku_count}"

  diagnostic_suffix = "-diagnostic"

  
  keyvault_name_length = 24
  keyvault_suffix      = var.keyvault_prefix
  keyvault_prefix      = "${local.prefix}-${var.component}"
  keyvault_final_name  = length(local.keyvault_prefix) > local.keyvault_name_length - length(local.keyvault_suffix) ? substr(local.keyvault_prefix, 0, local.keyvault_name_length - length(local.keyvault_suffix)) : local.keyvault_prefix
}

