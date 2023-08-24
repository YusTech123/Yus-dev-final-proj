data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "Yus_Key_test" {
  name                        = "yusvault2023"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "keyv_access_policy_1" {
  key_vault_id       = azurerm_key_vault.Yus_Key_test.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = "ff0cfbc1-e7ae-4846-8146-322bfbc8995d"
  key_permissions    = ["Get", "List"] # Use "List" permission separately
  secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]

  depends_on = [azurerm_key_vault.Yus_Key_test]
}

