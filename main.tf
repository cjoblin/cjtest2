terraform {
  required_version = ">= 0.13.00"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.46.0"
    }
  }
}

variable "targetSubscription"{
	type = string
}
variable "tenantID"{
	type = string
}
variable "deploymentAppID"{
	type = string
}
variable "deploymentSecret"{
	type = string
}
variable "vnetCIDR"{
	type = string
}

# Configure the provider
provider "azurerm" {
  features {}
  subscription_id = var.targetSubscription
  tenant_id       = var.tenantID
  client_id       = var.deploymentAppID
  client_secret   = var.deploymentSecret
}

#resource "azurerm_resource_group" "rg-dnstest" {
#  name     = "rg-dnstest"
#  location = "Australia East"
#}

#resource "azurerm_dns_zone" "dns-testdomain" {
#  name                = "testdomain.com"
#  resource_group_name = azurerm_resource_group.rg-dnstest.name
#}

#resource "azurerm_dns_zone" "dns-subdomain" {
#  name                = "sub.testdomain.com"
#  resource_group_name = azurerm_resource_group.rg-dnstest.name
#}

resource "azurerm_dns_a_record" "example" {
  name                = "testnp1"
  zone_name	      = "sub.testdomain.com"
  resource_group_name = "rg-dnstest"
#  link state from parent deployment later - just need permissions/state sharing for now
#  zone_name           = azurerm_dns_zone.dns-subdomain.name
#  resource_group_name = azurerm_resource_group.rg-dnstest.name
  ttl                 = 300
  records             = ["10.0.180.17"]
}

