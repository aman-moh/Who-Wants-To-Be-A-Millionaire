provider "azurerm" {
    features{}  
}

resource "azurerm_resource_group" "wwtbamrg" {
    name = "wwtbamrg"
    location = "West Europe"
}

resource "azurerm_storage_account" "wwtbamstr" {
  name = "wwtbamstr"
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  location = "UK West"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_static_web_app" "wwtbamweb" {
    name = "wwtbamweb"
    location = azurerm_resource_group.wwtbamrg.location
    resource_group_name = azurerm_resource_group.wwtbamrg.name
    sku_tier = "Free"
}