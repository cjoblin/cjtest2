terraform {
  required_version = ">= 0.13.00"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.46.0"
    }
  }
}

#variable "targetSubscription"{
#	type = string
#}
#variable "tenantID"{
#	type = string
#}
#variable "deploymentAppID"{
#	type = string
#}
variable "deploymentSecret"{
	type = string
}
variable "vnetCIDR"{
	type = string
}

# Configure the provider
provider "azurerm" {
  features {}
#  subscription_id = var.targetSubscription
#  tenant_id       = var.tenantID
#  client_id       = var.deploymentAppID
#  client_secret   = var.deploymentSecret
}

resource "azurerm_resource_group" "rg-dnstest" {
  name     = "rg-dnstest"
  location = "Australia East"
}

resource "azurerm_dns_zone" "dns-testdomain" {
  name                = "testdomain.com"
  resource_group_name = azurerm_resource_group.rg-dnstest.name

#  lifecycle {
#        ignore_changes = ["number_of_record_sets"]
#    }
}

resource "azurerm_dns_zone" "dns-subdomain" {
  name                = "sub.testdomain.com"
  resource_group_name = azurerm_resource_group.rg-dnstest.name
}

resource "azurerm_role_definition" "dns-subdomain-writer" {
  name               = "dns-subdomain-writer"
  scope              = azurerm_dns_zone.dns-testdomain.id

  permissions {
    actions     = ["Microsoft.Network/dnsZones/A/write", 
	    	   "Microsoft.Network/dnszones/A/delete",
	    	   "Microsoft.Network/dnszones/AAAA/write",
	    	   "Microsoft.Network/dnszones/AAAA/delete",
	    	   "Microsoft.Network/dnszones/CAA/write",
	    	   "Microsoft.Network/dnszones/CAA/delete",
	    	   "Microsoft.Network/dnszones/CNAME/write",
	    	   "Microsoft.Network/dnszones/CNAME/delete",
	   	   "Microsoft.Network/dnszones/MX/write",
	    	   "Microsoft.Network/dnszones/MX/delete",
	    	   "Microsoft.Network/dnszones/NS/write",
	    	   "Microsoft.Network/dnszones/NS/delete",
	    	   "Microsoft.Network/dnszones/PTR/write",
	    	   "Microsoft.Network/dnszones/PTR/delete",
	    	   "Microsoft.Network/dnszones/SOA/write",
	    	   "Microsoft.Network/dnszones/SRV/write",
	    	   "Microsoft.Network/dnszones/SRV/delete",
	    	   "Microsoft.Network/dnszones/TXT/write",
	    	   "Microsoft.Network/dnszones/TXT/delete",
    		   "Microsoft.Network/dnszones/all/read"
    		   ]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_dns_zone.dns-testdomain.id ,
    azurerm_dns_zone.dns-subdomain.id
  ]
}

resource "azurerm_role_assignment" "dns-subdomain-np1-assign" {
  scope              = azurerm_dns_zone.dns-subdomain.id
  role_definition_id = azurerm_role_definition.dns-subdomain-writer.role_definition_resource_id
  principal_id       = "17328cd2-4ba0-4c07-bb22-6d3154362bf5"
  #need to integrate with user creation later
}
