provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-lab"
    storage_account_name = "samfonfs2022"
    container_name       = "tfstate"
    key                  = "rg-mfo-nfs-2022.tfstate"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "grpAlexTP"
  location = "France Central"
}

resource "azurerm_service_plan" "example" {
  name                = "ASP-grpAlexTP-a153"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "S1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "example" {
  name                = "ASP-grpAlexTP-a153"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}

  connection_string {
    name = "MyDBConnection"
    type = "SQLAzure
    value= azurerm_mssql_database.example.connection_string
  }

  application_stack {}
}


resource "azurerm_mssql_server" "example" {
  name                         = "sql-alex-vesier"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "sqlAdminAlex"
  administrator_login_password = "Destiny76+"
}

resource "azurerm_mssql_database" "test" {
  name           = "mydb"
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"


}