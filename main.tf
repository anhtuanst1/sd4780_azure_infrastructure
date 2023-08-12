terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tuanphama3_rg" {
  name     = "tuanphama3ResourceGroup"
  location = "Southeast Asia"
}

resource "azurerm_virtual_network" "tuanphama3_vnet" {
  name                = "tuanphama3VirtualNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tuanphama3_rg.location
  resource_group_name = azurerm_resource_group.tuanphama3_rg.name
}

resource "azurerm_container_registry" "tuanphama3_acr" {
  name                = "tuanphama3ContainerRegistry"
  location            = azurerm_resource_group.tuanphama3_rg.location
  resource_group_name = azurerm_resource_group.tuanphama3_rg.name
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "tuanphama3_aks" {
  name                = "tuanphama3AKSCluster"
  location            = azurerm_resource_group.tuanphama3_rg.location
  resource_group_name = azurerm_resource_group.tuanphama3_rg.name
  dns_prefix          = "tuanphama3aksdns"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v3"
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  tags = {
    environment = "dev"
  }
}