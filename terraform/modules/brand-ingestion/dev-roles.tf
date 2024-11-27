# locals {
#   key_vault_role_assignment = flatten([
#       for user_id in toset(var.genai_dev_user_ids) : [
#         for role in ["Key Vault Reader", "Key Vault Secrets User", "Key Vault Secrets Officer"] : {
#           user_id      = user_id
#           role         = role
#         }
#     ]
#   ])

#   data_factory_role_assignment = flatten([
#     for user_id in toset(var.genai_dev_user_ids) : [
#       for role in ["Data Factory Contributor"] : {
#         user_id = user_id
#         role    = role
#       }
#     ]
#   ])
# }

# resource "azurerm_role_assignment" "genai-keyvault-roles" {
#   for_each = {
#     for ra in local.key_vault_role_assignment : "${ra.user_id}-${ra.role}" => ra
#   }
#   principal_id         = each.value["user_id"]
#   scope                = azurerm_key_vault.genai-keyvaultt.id
#   role_definition_name = each.value["role"]
# }

# resource "azurerm_role_assignment" "data-factory-roles" {
#   for_each = {
#     for ra in local.data_factory_role_assignment : "${ra.user_id}-${ra.role}" => ra
#   }
#   principal_id         = each.value["user_id"]
#   scope                = azurerm_data_factory.data_factory.id
#   role_definition_name = each.value["role"]
# }
