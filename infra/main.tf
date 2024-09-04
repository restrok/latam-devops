provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {}
variable "region" {}
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

variable "buckets" {
  type = map(object({
    name                        = string
    location                    = string
    uniform_bucket_level_access = bool
    cors                        = list(object({
      max_age_seconds = number
      method          = list(string)
      origin          = list(string)
      response_header = list(string)
    }))
    lifecycle_age             = number
    versioning_enabled        = bool
    logging_log_bucket        = string
    logging_log_object_prefix = string
    website_main_page_suffix  = string
    website_not_found_page    = string
  }))
}

module "storage" {
  source = "./submodules/cloud-storage"

  for_each = var.buckets

  name                        = each.value.name
  location                    = each.value.location
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  cors                        = each.value.cors
  lifecycle_age               = each.value.lifecycle_age
  versioning_enabled          = each.value.versioning_enabled
  logging_log_bucket          = each.value.logging_log_bucket
  logging_log_object_prefix   = each.value.logging_log_object_prefix
  website_main_page_suffix    = each.value.website_main_page_suffix
  website_not_found_page      = each.value.website_not_found_page
}

module "pubsub" {
  source = "./submodules/pubsub"

  topic_name        = var.pubsub_topic
  subscription_name = "process-data-subscription"
  push_endpoint     = module.cloud_functions["process_data"].https_trigger_url
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
  bucket_name        = module.storage["function_code"].name
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

resource "random_id" "id" {
  byte_length = 8
}