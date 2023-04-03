terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.46.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "nbt-rg-test"
    storage_account_name = "nbtteststorage"
    container_name = "terraform-backend"
    key = "terraform.tfstate"
    use_msi              = true
    subscription_id ="fe0a3c7c-f676-4acb-91ac-89f5008cbba1"
    tenant_id = "1a93b615-8d62-418a-ac28-22501cf1f978"
  }
}

provider "azurerm" {
  features {
  }
  use_msi              = true
  subscription_id ="fe0a3c7c-f676-4acb-91ac-89f5008cbba1"
  tenant_id = "1a93b615-8d62-418a-ac28-22501cf1f978"
}


resource "azurerm_resource_group" "rg" {
  name     = "example-resources"
  location =  var.location
}

resource "azurerm_mysql_flexible_server" "db-server" {
  name                   = var.db_server_name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1s"
  zone                   = "1"
}

resource "azurerm_mysql_flexible_server_configuration" "require-secure-transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db-server.name
  value               = "OFF"
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db-server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow-azure-resources" {
  name                = "AllowAzureResources"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "wordpress"
    image  = "nbt/wordpress"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}