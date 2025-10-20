output "subnet_id" {
  description = "ID til subnettet"
  value       = azurerm_subnet.subnet.id
}

output "vnet_id" {
  description = "ID til VNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Navn på VNet"
  value       = azurerm_virtual_network.vnet.name
}

output "nsg_id" {
  description = "ID til NSG"
  value       = azurerm_network_security_group.nsg.id
}
