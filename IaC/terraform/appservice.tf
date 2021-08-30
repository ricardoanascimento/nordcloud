resource "azurerm_app_service" "prod" {
  name                = "${var.env_prefix}"
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  app_service_plan_id = azurerm_app_service_plan.prod.id

  site_config {
    always_on          = true
    # linux_fx_version   = "DOCKER|ghost:latest"
    ip_restriction     = [
      {
        service_tag               = "AzureFrontDoor.Backend",
        name                      = "FrontDoorOnly"
        description               = "Make sure user wont be accessing the application using its url"
        priority                  = 300
        action                    = "Allow"
        headers = []
        ip_address = null
        virtual_network_subnet_id = null
      },
      {
        service_tag               = "${var.allowed_service_tag_active}",
        name                      = "AppServiceSameRegionOnly"
        description               = "Allow AppService and Functions within the same region"
        priority                  = 300
        action                    = "Allow"
        headers = []
        ip_address = null
        virtual_network_subnet_id = null
      }
    ]
  }

  app_settings = {
    database__connection__host          = "${azurerm_mysql_server.prod.name}.mysql.database.azure.com"
    database__connection__port          = "3306"
    database__connection__user          = "${var.mysql_administrator_login}@${azurerm_mysql_server.prod.name}"
    database__connection__password      = "${var.mysql_administrator_login_password}"
    database__connection__database      = "ghost"
    database__connection__ssl           = "true"
    WEBSITES_PORT                       = "2368"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    NODE_ENV                            = "production"
    url                                 = "https://ghost-FrontDoor.azurefd.net"
  }
}

resource "azurerm_app_service_slot" "dev" {
  name                = "dev"
  app_service_name    = azurerm_app_service.prod.name
  location            = azurerm_resource_group.active_rg.location
  resource_group_name = azurerm_resource_group.active_rg.name
  app_service_plan_id = azurerm_app_service_plan.staging.id

  site_config {
    always_on          = true
    # linux_fx_version   = "DOCKER|ghost:latest"  
  }

  app_settings = {
    database__connection__database      = "ghost-dev"
    database__connection__host          = "${azurerm_mysql_server.staging.name}.mysql.database.azure.com"
    database__connection__user          = "${var.mysql_administrator_login}@${azurerm_mysql_server.staging.name}"
    database__connection__password      = "${var.mysql_administrator_login_password}"
    WEBSITES_PORT                       = "2368"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    NODE_ENV                            = "production"
    url                                 = "https://${var.env_prefix}-dev.azurewebsites.net"
  }
}

resource "azurerm_app_service" "prod_standby" {
  name                = "${var.env_prefix}-standby"
  location            = azurerm_resource_group.standby_rg.location
  resource_group_name = azurerm_resource_group.standby_rg.name
  app_service_plan_id = azurerm_app_service_plan.prod_standby.id

  site_config {
    always_on          = true
    # linux_fx_version   = "DOCKER|ghost:latest"
    ip_restriction     = [
      {
        service_tag               = "AzureFrontDoor.Backend",
        name                      = "FrontDoorOnly"
        description               = "Make sure user wont be accessing the application using its url"
        priority                  = 300
        action                    = "Allow"
        headers = []
        ip_address = null
        virtual_network_subnet_id = null
      },
      {
        service_tag               = "${var.allowed_service_tag_standby}",
        name                      = "AppServiceSameRegionOnly"
        description               = "Allow AppService and Functions within the same region"
        priority                  = 300
        action                    = "Allow"
        headers = []
        ip_address = null
        virtual_network_subnet_id = null
      }
    ]   
  }

  app_settings = {
    database__connection__host          = "${azurerm_mysql_server.prod.name}.mysql.database.azure.com"
    database__connection__port          = "3306"
    database__connection__user          = "${var.mysql_administrator_login}@${azurerm_mysql_server.prod.name}"
    database__connection__password      = "${var.mysql_administrator_login_password}"
    database__connection__database      = "ghost"
    database__connection__ssl           = "true"
    WEBSITES_PORT                       = "2368"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    NODE_ENV                            = "production"
    url                                 = "https://ghost-FrontDoor.azurefd.net"
  }
}

resource "azurerm_app_service_slot" "dev_standby" {
  name                = "dev"
  app_service_name    = azurerm_app_service.prod_standby.name
  location            = azurerm_resource_group.standby_rg.location
  resource_group_name = azurerm_resource_group.standby_rg.name
  app_service_plan_id = azurerm_app_service_plan.staging_standby.id

  site_config {
    always_on          = true
    # linux_fx_version   = "DOCKER|ghost:latest"  
  }

  app_settings = {
    database__connection__database      = "ghost-dev"
    database__connection__host          = "${azurerm_mysql_server.staging.name}.mysql.database.azure.com"
    database__connection__user          = "${var.mysql_administrator_login}@${azurerm_mysql_server.staging.name}"
    database__connection__password      = "${var.mysql_administrator_login_password}"
    WEBSITES_PORT                       = "2368"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    NODE_ENV                            = "production"
    url                                 = "https://${var.env_prefix}-standby-dev.azurewebsites.net"
  }
}