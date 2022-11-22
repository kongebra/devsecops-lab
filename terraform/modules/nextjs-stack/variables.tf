variable "prefix" {
  type = string
}

variable "name" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "sku_name" {
  type    = string
  default = "P1v2"
}

variable "always_on" {
  type    = bool
  default = true
}

variable "app_command_line" {
  type    = string
  default = "node server.js"
}

variable "db_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "enable_database" {
  type    = bool
  default = true
}

variable "db_administrator_login" {
  type    = string
  default = "psqladmin"
}
