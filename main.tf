resource "azurerm_point_to_site_vpn_gateway" "main" {
  name                = "vpng-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  virtual_hub_id              = var.virtual_hub_id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.main.id
  scale_unit                  = var.scale_unit
  dns_servers                 = var.dns_servers
  tags                        = var.tags

  connection_configuration {
    name = "${var.name}-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [var.address_space]
    }
  }

}

resource "azurerm_vpn_server_configuration" "main" {

  name                     = "vpng-${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  vpn_authentication_types = ["AAD"]
  vpn_protocols            = ["OpenVPN"]

  azure_active_directory_authentication {
    tenant   = "https://login.microsoftonline.com/${var.tenant_id}/"
    audience = var.audience
    issuer   = "https://sts.windows.net/${var.tenant_id}/"
  }

}
