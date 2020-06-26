# Configure the Azure provider
provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "dad95817-dfb9-4e87-a075-cd5c7da61d9d"
  client_id       = "3ece50b0-d8d7-4dfa-8aa9-455ffa6d9ef3"
  client_secret   = "L72-7_Kh~DbTlKBzxo3plYYDK1HD-Lev69"
  tenant_id       = "ae3ee3ae-cc1c-4edd-b3c1-4f141e64fc42"
  features {}
}
resource "azurerm_resource_group" "slotDemo" {
  name     = "slotDemoResourceGroup"
  location = "westus2"
}

resource "azurerm_app_service_plan" "slotDemo" {
  name                = "slotAppServicePlan"
  location            = azurerm_resource_group.slotDemo.location
  resource_group_name = azurerm_resource_group.slotDemo.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.slotDemo.name
  }

  byte_length = 8
}
resource "azurerm_app_service" "slotDemo" {
  name                = "slotAppService${random_id.randomId.hex}"
  location            = azurerm_resource_group.slotDemo.location
  resource_group_name = azurerm_resource_group.slotDemo.name
  app_service_plan_id = azurerm_app_service_plan.slotDemo.id
}

resource "azurerm_app_service_slot" "slotDemo" {
    name                = "slotAppServiceSlotOne${random_id.randomId.hex}"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
    app_service_name    = azurerm_app_service.slotDemo.name
}
