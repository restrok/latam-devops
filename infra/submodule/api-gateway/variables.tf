variable "project_id" {}
variable "region" {}
variable "api_name" {}
variable "api_config_name" {}
variable "gateway_name" {}
variable "functions" {
  type = map(string)
}