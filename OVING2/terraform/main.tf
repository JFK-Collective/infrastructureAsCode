# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location

  tags = local.common_tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  min_tls_version = "TLS1_2"

  tags = local.common_tags
}

# comment more comment
# Storage Container
resource "azurerm_storage_container" "oblig" {
  name                  = "oblig-data"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}