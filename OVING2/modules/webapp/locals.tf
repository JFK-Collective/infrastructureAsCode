locals {
    app_plan_name = "${var.name_prefix}-app-plan-${var.environment}"
    webapp_name   = "${var.name_prefix}-webapp-${var.environment}"
    tags = {}
}