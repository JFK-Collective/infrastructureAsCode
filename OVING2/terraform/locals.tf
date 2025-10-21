locals {
  # Standardized resource names
  resource_group_name = "rg-${var.prefix}-${var.project_name}-${var.environment}"
  storage_account_name = "st${var.prefix}${var.project_name}${var.environment}"

  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    ManagedBy   = "jorgefk"
    Project     = var.project_name
    costcode    = "sjakalaka"
  }
}