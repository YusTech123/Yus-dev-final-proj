resource "azurerm_virtual_network" "yusufnet" {
  name                = "yus1-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "yusfe-subnet" {
  name                 = "fe-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.yusufnet.name
  address_prefixes     = ["10.0.1.0/26"]
  service_endpoints    = ["Microsoft.Web"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }

  }

  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_subnet" "yusbe-subnet" {
  name                 = "be-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.yusufnet.name
  address_prefixes     = ["10.0.0.64/26"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }

  lifecycle {
    ignore_changes = [delegation]
  }
}