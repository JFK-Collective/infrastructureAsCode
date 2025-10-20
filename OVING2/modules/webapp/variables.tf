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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Ekstra tags"
}


#Eventuelle subnet og nsg id'er

variable "subnet_id" {
  type        = string
  description = "ID til subnet der webservere skal plasseres"
}

variable "nsg_id" {
  type        = string
  description = "ID til NSG som skal assosieres med subnet"
}


