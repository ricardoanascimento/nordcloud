resource "azurerm_app_service_plan" "prod" {
  name                = "${var.env_prefix}-prod-app-service-plan"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "staging" {
  name                = "${var.env_prefix}-staging-app-service-plan"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "prod_standby" {
  name                = "${var.env_prefix}-prod-app-service-plan"
  location            = azurerm_resource_group.standby_rg.location
  resource_group_name = azurerm_resource_group.standby_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "staging_standby" {
  name                = "${var.env_prefix}-staging-app-service-plan"
  location            = azurerm_resource_group.standby_rg.location
  resource_group_name = azurerm_resource_group.standby_rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}