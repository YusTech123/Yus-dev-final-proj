output "resource_group_id" {
  value = azurerm_resource_group.rg.id

}

output "frontend-url" {
  value = "${azurerm_linux_web_app.feapp.name}.azurewebsites.net"

}

output "backend_url" {

  value = "${azurerm_linux_function_app.be-app.name}azurewebsites.net"

}