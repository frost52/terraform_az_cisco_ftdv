# FTD VMs

resource "azurerm_virtual_machine" "vm_ftdv" {
  count = var.vm_count
  name  = "ftd_vm_${format("%02d", count.index)}"

  resource_group_name = azurerm_resource_group.rg0.name
  location            = azurerm_resource_group.rg0.location
  vm_size             = "Standard_D3_V2"
  network_interface_ids = [
    azurerm_network_interface.mgmt_nic[count.index].id,
    azurerm_network_interface.diag_nic[count.index].id,
    azurerm_network_interface.outside_nic[count.index].id,
    azurerm_network_interface.inside_nic[count.index].id,
  ]
  primary_network_interface_id     = azurerm_network_interface.mgmt_nic[count.index].id
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  availability_set_id              = azurerm_availability_set.avset.id

  os_profile {
    #Linux VM name can't contain "_"
    #computer_name  = "ftd_vm_${format("%02d", count.index)}"
    computer_name  = "ftd-vm-${format("%02d", count.index)}"
    admin_username = var.username
    admin_password = var.password
    #to deploy ftd appliance within FMC registration data uncomment following line
    #custom_data    = base64encode("{\"AdminPassword\":\"${var.password}\",\"Hostname\":\"ftd_vm_${format("%02d", count.index)}\",\"FmcIp\":\"${var.fmc_ip}\",\"FmcRegKey\":\"${random_id.fmc_registerkey[count.index].b64_url}\",\"FmcNatId\":\"${random_id.fmc_natkey[count.index].b64_url}\"}")
  }

  storage_os_disk {
    name              = "ftd_vm_${format("%02d", count.index)}_disk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-ftdv"
    sku       = "ftdv-azure-byol"
    #actual version at the moment
    #version = "66190.0.0"
    version = "66191.0.0"
  }

  plan {
    publisher = "cisco"
    product   = "cisco-ftdv"
    name      = "ftdv-azure-byol"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.logs_sa.primary_blob_endpoint
  }
}

# Availability set for FTD VMs

resource "azurerm_availability_set" "avset" {
  name                = "avset"
  resource_group_name = azurerm_resource_group.rg0.name
  location            = azurerm_resource_group.rg0.location
}

# Storage account for FTD boot logs

resource "azurerm_storage_account" "logs_sa" {
  name                     = "ftdvbootlogs"
  resource_group_name      = azurerm_resource_group.rg0.name
  location                 = azurerm_resource_group.rg0.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}