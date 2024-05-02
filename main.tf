provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "wwtbamrg" {
  name     = "wwtbamrg"
  location = "West Europe"
}

resource "azurerm_storage_account" "wwtbamstr" {
  name                      = "wwtbamstr"
  resource_group_name       = azurerm_resource_group.wwtbamrg.name
  location                  = "UK West"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "wwtbamstrblob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.wwtbamstr.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}

resource "azurerm_static_web_app" "wwtbamweb" {
  name                = "wwtbamweb"
  location            = azurerm_resource_group.wwtbamrg.location
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  sku_tier            = "Free"
}