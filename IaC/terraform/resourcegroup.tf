resource "azurerm_resource_group" "active_rg" {
  name     = "active-rg"
  location = "West Europe"
}

resource "azurerm_resource_group" "standby_rg" {
  name     = "standby-rg"
  location = "UK South"
}