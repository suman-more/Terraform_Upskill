resource "azurerm_storage_account" "storage_account" {
  name                      = "${local.storage_final_name}${local.storage_suffix}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = true
  tags                      = var.tags
}