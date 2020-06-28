# Configure the Azure provider
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "2489a3c7-9e54-4074-a38d-eb3af3bdc14f"
  client_id       = "598fe56e-920e-428d-b16a-4b9386497ce3"
  client_secret   = "jL6hqfkrx63b5N-2.E0S5h0.FFpu.5Pp4x"
  tenant_id       = "c0447ee7-7b4a-40e6-85b3-dc6eda2714de"
  features {}
}
resource "azurerm_resource_group" "webrg1" {
  name     = "webapprg"
  location = "eastus"
}

resource "azurerm_app_service_plan" "webplan1" {
  name                = "slotAppServicePlan02"
  location            = azurerm_resource_group.webrg1.location
  resource_group_name = azurerm_resource_group.webrg1.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.webrg1.name
  }

  byte_length = 8
}
resource "azurerm_app_service" "webapp1" {
  name                = "slotAppService100${random_id.randomId.hex}"
  location            = azurerm_resource_group.webrg1.location
  resource_group_name = azurerm_resource_group.webrg1.name
  app_service_plan_id = azurerm_app_service_plan.webplan1.id
}

resource "azurerm_app_service_slot" "slotDemo1" {
    name                = "slotAppServiceSlotOne100${random_id.randomId.hex}"
    location            = azurerm_resource_group.webrg1.location
    resource_group_name = azurerm_resource_group.webrg1.name
    app_service_plan_id = azurerm_app_service_plan.webplan1.id
    app_service_name    = azurerm_app_service.webapp1.name
}
