resource "azurerm_virtual_network" "vn1" {
  name                = "sampledmangos-testing-vn1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "sub1" {
  name                 = "sampledmangos-testing-sub1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefixes     = ["10.1.0.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "nprofile1" {
  name                = "sampledmangos-testing-networkprofile1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  container_network_interface {
    name = "sampledmangos-testing-examplecnic"

    ip_configuration {
      name      = "sampledmangos-exampleipconfig"
      subnet_id = azurerm_subnet.sub1.id
    }
  }
}