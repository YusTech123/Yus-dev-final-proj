resource "azurerm_linux_web_app" "feapp" {
  name                = "yustestenviroment"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.front-asp.id

  site_config {
    minimum_tls_version = "1.2"
    always_on           = false

    application_stack {
      node_version = "16-lts"
    }
  }

  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.yus-appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }


  depends_on = [azurerm_service_plan.front-asp, azurerm_application_insights.yus-appinsights]
}
# Backend storage account for Function applications 
resource "azurerm_storage_account" "yusstoreaccount" {
  name                     = "yusfunctionapp2023"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


}
resource "azurerm_linux_function_app" "be-app" {
  name                = "be-app-function"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.yusstoreaccount.name
  storage_account_access_key = azurerm_storage_account.yusstoreaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.back-asp.id

  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.yus-appinsights.instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"


  }
  site_config {

    ip_restriction {
      virtual_network_subnet_id = azurerm_subnet.yusfe-subnet.id
      priority                  = 100
      name                      = "frontend access only"


    }

    application_stack {
      python_version = 3.8
    }
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_storage_account.yusstoreaccount]
}

#Backend functions is what I'm intergrating here. 
resource "azurerm_app_service_virtual_network_swift_connection" "vnet-be-intergration" {
  app_service_id = azurerm_linux_function_app.be-app.id
  subnet_id      = azurerm_subnet.yusbe-subnet.id

  depends_on = [azurerm_linux_function_app.be-app]
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet-fe-intergration" {
  app_service_id = azurerm_linux_web_app.feapp.id
  subnet_id      = azurerm_subnet.yusfe-subnet.id

  depends_on = [azurerm_linux_web_app.feapp]
}
