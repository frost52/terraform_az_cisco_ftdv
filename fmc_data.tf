#  FMC register/nat keys

resource "random_id" "fmc_registerkey" {
  count       = var.vm_count
  byte_length = 4
}
resource "random_id" "fmc_natkey" {
  count       = var.vm_count
  byte_length = 4
}