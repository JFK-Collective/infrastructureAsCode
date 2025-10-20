variable "rg_name" {
  type        = string
  description = "Navn på Resource Group opprettet i miljøet"
}

variable "location"     { type = string }
variable "environment"  { type = string }
variable "name_prefix"  { 
  type = string
  }

variable "vnet_cidr" {
  type    = string
}
variable "subnet_cidr" {
  type    = string
}
variable "allow_ssh_cidr" {
  type    = string
  default = null
}

variable "admin_username"   {
  type = string 
}

variable "allocate_public_ip" {
  type = bool
  default = true 
}

variable "tags" {
  type = map(string)
  default = {} 
}
