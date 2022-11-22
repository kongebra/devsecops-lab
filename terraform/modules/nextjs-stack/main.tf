locals {
  name = "${var.prefix}-${var.name}-${var.environment}"
}

resource "random_password" "db_password" {
  length  = 16
  special = true
  upper   = true
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name}-rg"
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = "${local.name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.sku_name
}

resource "azurerm_linux_web_app" "app" {
  name                = "${local.name}-linux-web-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    always_on        = var.always_on
    app_command_line = var.app_command_line
    http2_enabled    = true

    application_stack {
      node_version = "16-lts"
    }
  }

  # app_settings = {
  #   "DATABASE_URL" = "postgres://${var.db_administrator_login}:${random_password.db_password.result}@${azurerm_postgresql_flexible_server.db.fqdn}/postgres?sslmode=require"
  # }

  connection_string {
    name  = "DATABASE_URL"
    type  = "PostgreSQL"
    value = "postgres://${var.db_administrator_login}:${random_password.db_password.result}@${azurerm_postgresql_flexible_server.db.fqdn}/postgres?sslmode=require"
  }
}

resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "${local.name}-psqlflexibleserver"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  version                = "14"
  administrator_login    = var.db_administrator_login
  administrator_password = random_password.db_password.result
  storage_mb             = 32768
  sku_name               = var.db_sku
  zone                   = "2"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "db" {
  name             = "Allow_Azure_Resources"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
