# FTD NICs

resource "azurerm_network_interface" "mgmt_nic" {
  count = var.vm_count
  name                 = "mgmt_nic_${format("%02d", count.index)}"
  resource_group_name  = azurerm_resource_group.rg0.name
  location             = azurerm_resource_group.rg0.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "mgmt_nic_${format("%02d", count.index)}"
    subnet_id                     = azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface" "diag_nic" {
  count = var.vm_count
  name                 = "diag_nic_${format("%02d", count.index)}"
  resource_group_name  = azurerm_resource_group.rg0.name
  location             = azurerm_resource_group.rg0.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "diag_nic_${format("%02d", count.index)}"
    subnet_id                     = azurerm_subnet.diag_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "outside_nic" {
  #gi0/0
  count = var.vm_count
  name                 = "outside_nic_${format("%02d", count.index)}"
  resource_group_name  = azurerm_resource_group.rg0.name
  location             = azurerm_resource_group.rg0.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "outside_nic_${format("%02d", count.index)}"
    subnet_id                     = azurerm_subnet.outside_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "inside_nic" {
  #gi0/1
  count = var.vm_count
  name                 = "inside_nic_${format("%02d", count.index)}"
  resource_group_name  = azurerm_resource_group.rg0.name
  location             = azurerm_resource_group.rg0.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "inside_nic_${format("%02d", count.index)}"
    subnet_id                     = azurerm_subnet.inside_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}