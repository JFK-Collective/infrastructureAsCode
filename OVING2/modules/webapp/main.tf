resource "azurerm_service_plan" "app_plan" {
  name                = local.app_plan_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "F1"  # free tier
  tags                = local.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = local.webapp_name
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      docker_image_name = "nginx:latest"
    }
    always_on = false
  }

  tags = local.tags
}

