terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "wwtbamrg" {
  name     = "wwtbamrg"
  location = "West Europe"
}

resource "azurerm_storage_account" "wwtbamstr" {
  name                          = "wwtbamstr"
  resource_group_name           = azurerm_resource_group.wwtbamrg.name
  location                      = "UK West"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  enable_https_traffic_only     = true
  public_network_access_enabled = true

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

resource "azurerm_virtual_network" "vnet" {
  name                = "wwtbam-vnet"
  location            = azurerm_resource_group.wwtbamrg.location
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.wwtbamrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.wwtbamrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicip" {
  name                = "wwtbam-pip"
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  location            = azurerm_resource_group.wwtbamrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "test-appgw"
  location            = azurerm_resource_group.wwtbamrg.location
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.publicip.id
  }

  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}-private"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.10"
  }



  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = ["${azurerm_static_web_app.wwtbamweb3.name}.azurestaticapps.net"]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 1
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_static_web_app" "wwtbamweb3" {
  name                = "wwtbamweb-test-3"
  location            = azurerm_resource_group.wwtbamrg.location
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  sku_tier            = "Standard"
  sku_size            = "Standard"
}

resource "azurerm_private_endpoint" "wwtbamendpoint" {
  name                = "private-endpoint-wwtbamweb3-test"
  location            = azurerm_resource_group.wwtbamrg.location
  resource_group_name = azurerm_resource_group.wwtbamrg.name
  subnet_id           = azurerm_subnet.backend.id

  private_service_connection {
    name                           = "wwtbam-privateserviceconnection"
    private_connection_resource_id = azurerm_static_web_app.wwtbamweb3.id
    subresource_names              = ["staticSites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "wwtbam-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.wwtbampdns.id]
  }
}

resource "azurerm_private_dns_zone" "wwtbampdns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.wwtbamrg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "wwtbampdnslink" {
  name                  = "wwtbam-test-link"
  resource_group_name   = azurerm_resource_group.wwtbamrg.name
  private_dns_zone_name = azurerm_private_dns_zone.wwtbampdns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled = false
}
