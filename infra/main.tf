provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {}
variable "region" {}
variable "bucket_name" {}
variable "dataset_id" {}
variable "table_id" {}
variable "pubsub_topic" {}

variable "cloud_functions" {
  type = map(object({
    name               = string
    runtime            = string
    entry_point        = string
    source_directory   = string
    trigger_http       = bool
    event_trigger_type = string
    event_trigger_resource = string
    environment_variables = map(string)
  }))
}

resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
}

resource "google_pubsub_topic" "topic" {
  name = var.pubsub_topic
}

module "cloud_functions" {
  source = "./submodules/cloud-function"

  for_each = var.cloud_functions

  name               = each.value.name
  runtime            = each.value.runtime
  entry_point        = each.value.entry_point
  source_directory   = each.value.source_directory
  trigger_http       = each.value.trigger_http
  event_trigger_type = each.value.event_trigger_type
  event_trigger_resource = each.value.event_trigger_resource
  environment_variables = each.value.environment_variables
  region             = var.region
  project_id         = var.project_id
  bucket_name        = var.bucket_name
}

module "api_gateway" {
  source         = "./submodules/api-gateway"
  project_id     = var.project_id
  region         = var.region
  api_name       = "my-api"
  api_config_name = "my-api-config"
  gateway_name   = "my-gateway"
  functions = {
    upload_data = module.cloud_functions["upload_data"].https_trigger_url
    get_data    = module.cloud_functions["get_data"].https_trigger_url
  }
  openapi_template_path = "${path.module}/openapi.yaml.tpl"
}