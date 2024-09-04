variable "buckets" {
  description = "A map of buckets to create, where the key is the bucket name and the value is an object with bucket properties."
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