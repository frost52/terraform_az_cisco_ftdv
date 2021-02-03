# Internal LB //iLB

resource "azurerm_lb" "inside_lb" {
  name                = "inside_lb"
  resource_group_name = azurerm_resource_group.rg0.name
  location            = azurerm_resource_group.rg0.location
  sku                 = "Standard"

  frontend_ip_configuration {
    subnet_id                     = azurerm_subnet.inside_subnet.id
    name                          = "inside_lb"
    private_ip_address_allocation = "Dynamic"
  }
}

# Address pool for iLB

resource "azurerm_lb_backend_address_pool" "pool_inside_lb" {
  resource_group_name = azurerm_resource_group.rg0.name
  loadbalancer_id     = azurerm_lb.inside_lb.id
  name                = "pool_inside_lb"
}

# Address pool association for iLB

resource "azurerm_network_interface_backend_address_pool_association" "association_pool_inside_lb" {
  count                   = var.vm_count
  ip_configuration_name   = "inside_nic_${format("%02d", count.index)}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool_inside_lb.id
  network_interface_id    = azurerm_network_interface.inside_nic[count.index].id
}

# Load balancing rule for iLB

resource "azurerm_lb_rule" "rule_inside_lb" {
  resource_group_name            = azurerm_resource_group.rg0.name
  loadbalancer_id                = azurerm_lb.inside_lb.id
  name                           = "rule_inside_lb"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "inside_lb"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool_inside_lb.id
  probe_id                       = azurerm_lb_probe.probe_inside_lb.id
  disable_outbound_snat          = true
  load_distribution              = "SourceIPProtocol"
  #load_distribution             = "SourceIP"
}

# Detection probe rule for iLB

resource "azurerm_lb_probe" "probe_inside_lb" {
  ## ssh port used only just as work example
  ## also in some cases may be used captive portal port tcp/885
  resource_group_name = azurerm_resource_group.rg0.name
  loadbalancer_id     = azurerm_lb.inside_lb.id
  name                = "probe_inside_lb"
  port                = 22
  protocol            = "Tcp"
}