output "webapp_hostname" {
  description = "Default hostname of the deployed Linux Web App"
  value       = azurerm_linux_web_app.app.default_hostname
}