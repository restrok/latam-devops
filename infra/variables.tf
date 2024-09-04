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