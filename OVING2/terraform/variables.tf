variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "oblig2"
}

variable "prefix" {
  description = "Prefix used to mark objects as mine"
  type        = string
  default     = "jfk"
}

variable "account_tier" {
  description = "Storage Account performance tier"
  type        = string
}

variable "replication_type" {
  description = "Replication type for the Storage Account"
  type        = string
}
