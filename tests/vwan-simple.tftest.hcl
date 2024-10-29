provider "azurerm" {
  features {}
}

provider "azuread" {
}

variables {
  application_name = "aztf-test"
  location         = "westus3"
}

run "setup" {
  module {
    source = "./testing/setup"
  }
  providers = {
    azurerm = azurerm
  }
}

run "simple-vwan" {
  module {
    source = "./examples/vwan-simple"
  }

  variables {
    address_space      = "10.8.0.0/23"
    additional_regions = {}
    vpn_address_space  = "10.10.0.0/24"
  }

  providers = {
    azurerm = azurerm
    azuread = azuread
  }

  assert {
    condition     = length(module.vwan.id) > 0
    error_message = "Must have a valid V-WAN ID"
  }
}
