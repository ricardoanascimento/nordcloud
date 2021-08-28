resource "azurerm_mysql_database" "mysql_database_prod" {
  name                = "ghost"
  resource_group_name = azurerm_resource_group.active_rg.name
  server_name         = azurerm_mysql_server.prod.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_database" "mysql_database_dev" {
  name                = "ghost-dev"
  resource_group_name = azurerm_resource_group.active_rg.name
  server_name         = azurerm_mysql_server.staging.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}