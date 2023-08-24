resource "azurerm_service_plan" "front-asp" {
  name                = "yusfe-asp-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on          = [azurerm_subnet.yusfe-subnet]
}

resource "azurerm_service_plan" "back-asp" {
  name                = "yusbe-asp-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on          = [azurerm_subnet.yusbe-subnet]
}