#Outputs

output "mgmt_ip_address" {
  value = azurerm_network_interface.mgmt_nic[*].private_ip_address
}
output "outside_ip_address" {
  value = azurerm_network_interface.outside_nic[*].private_ip_address
}
output "inside_ip_address" {
  value = azurerm_network_interface.inside_nic[*].private_ip_address
}
output "fmc_registerkey" {
  value = random_id.fmc_registerkey[*].b64_url
}
output "fpmc_natkey" {
  value = random_id.fmc_natkey[*].b64_url
}
output "public_ip_external_lb" {
  value = azurerm_public_ip.public_ip_external_lb.ip_address
}