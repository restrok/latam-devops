variable "project_id" {}
variable "region" {}
variable "labels" {}
variable "schema_path" {}
variable "time_partitioning_type" {}
variable "project_prefix" {}
variable "cloud_functions_http" {}
variable "cloud_functions_event" {}


variable "buckets" {
  type = map(object({
    name = string
    # location                    = string
    uniform_bucket_level_access = bool
    cors = list(object({
      max_age_seconds = number
      method          = list(string)
      origin          = list(string)
      response_header = list(string)
    }))
    lifecycle_age      = number
    versioning_enabled = bool
    # logging_log_bucket        = string
    # logging_log_object_prefix = string
    # website_main_page_suffix  = string
    # website_not_found_page    = string
    notification_topic = string
  }))
}

variable "cloudbuild-config" {}