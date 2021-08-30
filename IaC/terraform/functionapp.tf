resource "azurerm_function_app" "prod" {
  name                       = "${var.env_prefix}-azure-functions-prod"
  location                   = azurerm_resource_group.active_rg.location
  resource_group_name        = azurerm_resource_group.active_rg.name
  app_service_plan_id        = azurerm_app_service_plan.prod.id
  storage_account_name       = azurerm_storage_account.prod.name
  storage_account_access_key = azurerm_storage_account.prod.primary_access_key
  os_type                    = "linux"
  version                    = "~3"

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = ""
    FUNCTIONS_WORKER_RUNTIME = "node"
    GHOST_URL = "https://ghost-frontdoor.azurefd.net"
    GHOST_ADMIN_KEY = "Replace by integration admin key"
  }
}

resource "azurerm_function_app" "dev" {
  name                       = "${var.env_prefix}-azure-functions-dev"
  location                   = azurerm_resource_group.active_rg.location
  resource_group_name        = azurerm_resource_group.active_rg.name
  app_service_plan_id        = azurerm_app_service_plan.staging.id
  storage_account_name       = azurerm_storage_account.staging.name
  storage_account_access_key = azurerm_storage_account.staging.primary_access_key
  os_type                    = "linux"
  version                    = "~3"

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = ""
    FUNCTIONS_WORKER_RUNTIME = "node"
    GHOST_URL = "https://ghost-frontdoor.azurefd.net"
    GHOST_ADMIN_KEY = "Replace by integration admin key"
  }
}