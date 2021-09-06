resource "azurerm_storage_account" "prod" {
  name                     = "${var.env_prefix}prod"
  resource_group_name      = azurerm_resource_group.active_rg.name
  location                 = azurerm_resource_group.active_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "prod" {
  name                  = "databaseblob"
  storage_account_name  = azurerm_storage_account.prod.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "prod" {
  name                 = "contentfiles"
  storage_account_name = azurerm_storage_account.prod.name
  quota                = 50
}

resource "azurerm_storage_account" "staging" {
  name                     = "${var.env_prefix}staging"
  resource_group_name      = azurerm_resource_group.active_rg.name
  location                 = azurerm_resource_group.active_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "staging" {
  name                  = "databaseblobstaging"
  storage_account_name  = azurerm_storage_account.staging.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "staging" {
  name                 = "contentfilesstaging"
  storage_account_name = azurerm_storage_account.staging.name
  quota                = 50
}