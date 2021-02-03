# Variables

variable "region" {
  description = "Region"
  type        = string
}
variable "username" {
  description = "Username for Virtual Machines"
  type        = string
}
variable "password" {
  description = "Password for Virtual Machines"
  type        = string
}
variable "vm_count" {
  description = "Count of FTD appliances"
  type        = number
}
variable "subnet" {
  description = "Subnet for VM nics"
  type        = string
}