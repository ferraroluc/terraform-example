variable "access_key" {
    type = string
}
variable "secret_key" {
    type = string
}
variable "FLASK_APP" {
    type = string
}
variable "APP_SETTINGS" {
    type = string
}
variable "dbName" {
    type = string
}
variable "dbUser" {
    type = string
}
variable "dbPass" {
    type = string
}
locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}