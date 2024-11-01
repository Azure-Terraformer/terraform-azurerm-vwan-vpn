resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# This obtains the Entra ID Provider Client Configuration
data "azuread_client_config" "current" {}
# This obtains a list of well-known Entra ID Applications
data "azuread_application_published_app_ids" "well_known" {}

locals {
  # Spearfish the Azure VPN Application ID from the well-known list
  azure_vpn_app_id = data.azuread_application_published_app_ids.well_known.result["AzureVPN"]
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${random_string.suffix.result}"
  location = var.location
}

module "vwan" {

  source  = "Azure-Terraformer/vwan/azurerm"
  version = "1.0.0"

  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  name                   = var.application_name
  primary_address_prefix = var.address_space
  additional_regions     = var.additional_regions

}


module "vpn" {

  source = "../../"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = "${var.application_name}-${random_string.suffix.result}"
  virtual_hub_id      = module.vwan.primary_virtual_hub_id
  address_space       = var.vpn_address_space
  tenant_id           = data.azuread_client_config.current.tenant_id
  audience            = local.azure_vpn_app_id

}
