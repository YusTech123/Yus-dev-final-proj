resource "azurerm_resource_group" "rg" {
  name     = "Yusuf-RG"
  location = var.location-rg
  tags = {
    "Application" = "3TierDemoApp"
  }


}
