# Public ip for external LB

resource "azurerm_public_ip" "public_ip_external_lb" {
  name                = "public_ip_external_lb"
  resource_group_name = azurerm_resource_group.rg0.name
  location            = azurerm_resource_group.rg0.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# External LB //eLB

resource "azurerm_lb" "outside_lb" {
  name                = "outside_lb"
  resource_group_name = azurerm_resource_group.rg0.name
  location            = azurerm_resource_group.rg0.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "outside_lb"
    public_ip_address_id = azurerm_public_ip.public_ip_external_lb.id
  }
}

# Address pool for eLB

resource "azurerm_lb_backend_address_pool" "pool_outside_lb" {
  resource_group_name = azurerm_resource_group.rg0.name
  loadbalancer_id     = azurerm_lb.outside_lb.id
  name                = "pool_outside_lb"
}

# Address pool association for eLB

resource "azurerm_network_interface_backend_address_pool_association" "association_pool_outside_lb" {
  count                   = var.vm_count
  ip_configuration_name   = "outside_nic_${format("%02d", count.index)}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool_outside_lb.id
  network_interface_id    = azurerm_network_interface.outside_nic[count.index].id
}

# Load balancing rule for eLB

resource "azurerm_lb_outbound_rule" "rule_ouside_lb" {
  resource_group_name     = azurerm_resource_group.rg0.name
  loadbalancer_id         = azurerm_lb.outside_lb.id
  name                    = "OutboundRule"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool_outside_lb.id

  frontend_ip_configuration {
    name = "outside_lb"
  }
}