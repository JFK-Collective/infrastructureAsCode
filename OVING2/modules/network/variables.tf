variable "rg_name" {
  type        = string
  description = "Navn på eksisterende rg der nettverksressurser skal opprettes"
}

variable "location" {
  type        = string
  description = "Azure-region (må samsvare med RG)"
}

variable "environment" {
  type        = string
  description = "Miljønavn (dev, test, prod)"
}

variable "name_prefix" {
  type        = string
  description = "Navneprefix for nettverksressurser"
}

variable "vnet_cidr"   { 
  type = string
  }
variable "subnet_cidr" {
  type    = string
}

variable "allow_ssh_cidr" {
  type        = string
  default     = null
  description = "Tillatt kilde-CIDR for SSH; null for å ikke åpne"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Ekstra tags"
}
