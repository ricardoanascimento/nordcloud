resource "azurerm_mysql_server" "prod" {
  name                = "${var.env_prefix}-prod-mysqlserver"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name

  administrator_login          = "${var.mysql_administrator_login}"
  administrator_login_password = "${var.mysql_administrator_login_password}"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_server" "staging" {
  name                = "${var.env_prefix}-staging-mysqlserver"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name

  administrator_login          = "${var.mysql_administrator_login}"
  administrator_login_password = "${var.mysql_administrator_login_password}"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}