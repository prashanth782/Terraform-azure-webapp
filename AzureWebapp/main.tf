# Configure the Azure provider
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "3b3fa41d-07bd-4c3b-a928-52315c0d594b"
  client_id       = "5f09174c-d654-4480-951a-28c115a03dd3"
  client_secret   = "w_Tj_ZwP79_0JJ4RcPZ~HcTL9Dj6Kj~Lo0"
  tenant_id       = "ce47baa1-4313-4bd7-8a90-496691fc0bb1"
  features {}
}

resource "azurerm_resource_group" "webrg2" {
  name     = "webapprg1"
  location = "eastus"
}

resource "azurerm_app_service_plan" "webplan2" {
  name                = "slotAppServicePlan04"
  location            = azurerm_resource_group.webrg2.location
  resource_group_name = azurerm_resource_group.webrg2.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.webrg2.name
  }

  byte_length = 8
}
resource "azurerm_app_service" "webapp2" {
  name                = "slotAppService400${random_id.randomId.hex}"
  location            = azurerm_resource_group.webrg2.location
  resource_group_name = azurerm_resource_group.webrg2.name
  app_service_plan_id = azurerm_app_service_plan.webplan2.id
}

resource "azurerm_app_service_slot" "slotDemo2" {
    name                = "slotAppServiceSlotOne400${random_id.randomId.hex}"
    location            = azurerm_resource_group.webrg2.location
    resource_group_name = azurerm_resource_group.webrg2.name
    app_service_plan_id = azurerm_app_service_plan.webplan2.id
    app_service_name    = azurerm_app_service.webapp2.name
}
