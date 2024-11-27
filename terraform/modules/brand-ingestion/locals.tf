locals {
  name_length = 44
  prefix      = "${var.region}-${var.context}-${var.system}-${var.env}"

  # Azure Data Factory and Integration runtime naming convention
  adf_suffix       = "-adf"
  adf_prefix       = "${local.prefix}-${var.component}"
  adf_final_name   = length(local.adf_prefix) > local.name_length - length(local.adf_suffix) ? substr(local.adf_prefix, 0, local.name_length - length(local.adf_suffix)) : local.adf_prefix
  
  ir_suffix        = "-ir"
  ir_prefix        = "${local.prefix}-${var.component}"
  ir_final_name    = length(local.ir_prefix) > local.name_length - length(local.ir_suffix) ? substr(local.ir_prefix, 0, local.name_length - length(local.ir_suffix)) : local.ir_prefix
  
  # ls_suffix        = "-ls"
  # ls_prefix        = "${local.prefix}-${var.component}"
  # ls_final_name    = length(local.ls_prefix) > local.name_length - length(local.ls_suffix) ? substr(local.ls_prefix, 0, local.name_length - length(local.ls_suffix)) : local.ls_prefix

  # Azure Storage Account naming convention
  storage_name_length  = 24
  storage_suffix       = "stgacct"
  st_prefix            = "${var.context}${var.system}${var.env}"
  storage_prefix       = "${local.st_prefix}${var.component}"
  storage_final_name   = length(local.storage_prefix ) > local.storage_name_length - length(local.storage_suffix) ? substr(local.storage_prefix, 0, local.storage_name_length - length(local.storage_suffix)) : local.storage_prefix

  # Azure App Service Plan and Azure Function App naming convention
  app_service_suffix       = "-app-Service"
  app_service_prefix       = "${local.prefix}-${var.component}"
  app_service_final_name   =  length(local.app_service_prefix) > local.name_length - length(local.app_service_suffix) ? substr(local.app_service_prefix, 0, local.name_length - length(local.app_service_suffix)) : local.app_service_prefix
 
  function_app_suffix      = "-funcing"
  function_app_prefix      = "${local.prefix}-${var.component}"
  function_app_final_name  = length(local.function_app_prefix) > local.name_length - length(local.function_app_suffix) ? substr(local.function_app_prefix, 0, local.name_length - length(local.function_app_suffix)) : local.function_app_prefix
  
  diagnostic_fun_app_suffix = "-diagnostic"
  
  # Azure application insights naming convention
  app_insights_suffix       = "-app-Insights"
  app_insights_prefix       = "${local.prefix}-${var.component}"
  app_insights_final_name   = length(local.app_insights_prefix ) > local.name_length - length(local.app_insights_suffix) ? substr(local.app_insights_prefix, 0, local.name_length - length(local.app_insights_suffix)) : local.app_insights_prefix    

  #Azure key vault naming convention
  keyvault_name_length = 20
  keyvault_suffix      = "-tkv"
  keyvault_prefix      = "${local.prefix}-${var.component}"
  keyvault_final_name  = length(local.keyvault_prefix) > local.keyvault_name_length - length(local.keyvault_suffix) ? substr(local.keyvault_prefix, 0, local.keyvault_name_length - length(local.keyvault_suffix)) : local.keyvault_prefix
  
  github_access_sp_name_length = 44
  github_access_sp_suffix      = "-id"
  github_access_sp_prefix      = "${local.prefix}-${var.component}-github"
  github_access_sp_final_name  = length(local.github_access_sp_prefix) > local.github_access_sp_name_length - length(local.github_access_sp_suffix) ? substr(local.github_access_sp_prefix, 0, local.github_access_sp_name_length - length(local.github_access_sp_suffix)) : local.github_access_sp_prefix
}