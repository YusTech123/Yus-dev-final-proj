resource "azurerm_log_analytics_workspace" "yus-loganalytics" {
  name                = "yus-la-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "yus-appinsights" {
  name                = "yus-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.yus-loganalytics.id
  application_type    = "web"
  depends_on = [
    azurerm_log_analytics_workspace.yus-loganalytics
  ]
}

output "instrumentation_key" {
  value     = azurerm_application_insights.yus-appinsights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value     = azurerm_application_insights.yus-appinsights
  sensitive = true
}