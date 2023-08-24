#Generate a random Password
resource "random_password" "randompass" {
  length           = 16
  special          = true
  override_special = "!#$&%*()-_+[]{}<>:?"

}

resource "azurerm_key_vault_secret" "Yussqladminpassword" {
  name         = "yussqladmin"
  value        = random_password.randompass.result
  key_vault_id = azurerm_key_vault.Yus_Key_test.id
  content_type = "text/plain"
  depends_on   = [azurerm_key_vault.Yus_Key_test, azurerm_key_vault_access_policy.keyv_access_policy_1]

}

resource "azurerm_mssql_server" "yussql1" {
  name                         = "yus-sqldb-test"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "admin@!2"
  administrator_login_password = random_password.randompass.result

  tags = {
    login_username = "Terraform Admin"
    object_id      = "ff0cfbc1-e7ae-4846-8146-322bfbc8995d"
  }


}

#This section I will add a subnet from the backvnet 

resource "azurerm_mssql_virtual_network_rule" "grant-be-access" {
  name       = "be-sql-vnet-rule"
  server_id  = azurerm_mssql_server.yussql1.id
  subnet_id  = azurerm_subnet.yusbe-subnet.id
  depends_on = [azurerm_mssql_server.yussql1]

}

resource "azurerm_mssql_database" "yus-database" {
  name           = "yus-db"
  server_id      = azurerm_mssql_server.yussql1.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    Application = "yus_devops-demo"
    Env         = "Production"
  }
}


resource "azurerm_key_vault_secret" "sqldb_cnxn" {
  name         = "yussqldbconstring"
  value        = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:yus-sqldb-test.database.windows.net,1433;Database=yus-db;Uid=admin;Pwd=${random_password.randompass.result};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.Yus_Key_test.id
  depends_on   = [azurerm_mssql_database.yus-database, azurerm_key_vault_access_policy.keyv_access_policy_1]
}
