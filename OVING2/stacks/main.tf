module "network" {
  source         = "../modules/network"
  rg_name        = var.rg_name
  location       = var.location
  environment    = var.environment
  name_prefix    = var.name_prefix
  vnet_cidr      = var.vnet_cidr
  subnet_cidr    = var.subnet_cidr
  allow_ssh_cidr = var.allow_ssh_cidr
  tags           = var.tags
}

module "web-app" {
    source = "../modules/webapp"
    rg_name = var.rg_name
    location = var.location
    environment = var.environment
    name_prefix = var.name_prefix

    #eventuelle subnet og nsg id'er
    subnet_id = module.network.subnet_id
    nsg_id = module.network.nsg_id
}

