variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "name" {
  type = string
}
variable "address_space" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "audience" {
  type = string
}
variable "virtual_hub_id" {
  type = string
}
variable "dns_servers" {
  type    = list(string)
  default = null
}
variable "scale_unit" {
  type    = number
  default = 1
}
variable "tags" {
  type    = map(string)
  default = {}
}
