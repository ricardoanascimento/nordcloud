resource "azurerm_storage_account" "prod" {
  name                     = "${var.env_prefix}prod"
  resource_group_name      = azurerm_resource_group.active_rg.name
  location                 = azurerm_resource_group.active_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "staging" {
  name                     = "${var.env_prefix}staging"
  resource_group_name      = azurerm_resource_group.active_rg.name
  location                 = azurerm_resource_group.active_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}