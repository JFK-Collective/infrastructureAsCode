locals {
  vnet_name = "vnet-${var.environment}-${var.name_prefix}"
  subnet_name = "snet-${var.environment}-${var.name_prefix}"
  nsg_name = "nsg-${var.environment}-${var.name_prefix}"
}