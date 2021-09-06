resource "azurerm_application_insights" "ai_appservice_active" {
  name                = "active-appinsights"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  application_type    = "Node.JS"
}

resource "azurerm_application_insights" "ai_appservice_standby" {
  name                = "standby-appinsights"
  location            = azurerm_resource_group.standby_rg.location
  resource_group_name = azurerm_resource_group.standby_rg.name
  application_type    = "Node.JS"
}

resource "azurerm_application_insights" "ai_function_active" {
  name                = "function-appinsights"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  application_type    = "Node.JS"
}
