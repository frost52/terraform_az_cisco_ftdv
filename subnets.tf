# VNET

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_hubvnet"
  location            = azurerm_resource_group.rg0.location
  resource_group_name = azurerm_resource_group.rg0.name
  address_space       = [var.subnet]          # /24 subnet
}

# Subnets

resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "mgmt-subnet"
  resource_group_name  = azurerm_resource_group.rg0.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 4,0)] # get 1st /28 subnet
}
resource "azurerm_subnet" "diag_subnet" {
  name                 = "diag-subnet"
  resource_group_name  = azurerm_resource_group.rg0.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 4,1)] # get 2nd /28 subnet
}
resource "azurerm_subnet" "outside_subnet" {
  name                 = "outside-subnet"
  resource_group_name  = azurerm_resource_group.rg0.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 4,2)] # get 3rd /28 subnet
}
resource "azurerm_subnet" "inside_subnet" {
  name                 = "inside-subnet"
  resource_group_name  = azurerm_resource_group.rg0.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 4,3)] # get 4th /28 subnet
}