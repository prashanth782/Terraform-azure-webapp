provider "azurerm" {
  version         = "=2.4.0"
  subscription_id = "dad95817-dfb9-4e87-a075-cd5c7da61d9d"
  client_id       = "3ece50b0-d8d7-4dfa-8aa9-455ffa6d9ef3"
  client_secret   = "L72-7_Kh~DbTlKBzxo3plYYDK1HD-Lev69"
  tenant_id       = "ae3ee3ae-cc1c-4edd-b3c1-4f141e64fc42"
  features {}
}

resource "azurerm_resource_group" "example1" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_app_service_plan" "example1" {
  name                = "example-appserviceplan01"
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example1" {
  name                = "example-apsp45687890"
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name
  app_service_plan_id = azurerm_app_service_plan.example1.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
