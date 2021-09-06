resource "azurerm_container_registry" "acr_active" {
  name                = "${var.env_prefix}activecr"
  resource_group_name = azurerm_resource_group.active_rg.name
  location            = azurerm_resource_group.active_rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_container_registry" "acr_standby" {
  name                = "${var.env_prefix}standbycr"
  resource_group_name = azurerm_resource_group.standby_rg.name
  location            = azurerm_resource_group.standby_rg.location
  sku                 = "Standard"
  admin_enabled       = true
}