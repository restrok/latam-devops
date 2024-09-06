variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket level access."
  type        = bool
}

variable "lifecycle_age" {
  description = "The age in days to delete objects."
  type        = number
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket."
  type        = bool
}

# variable "logging_log_bucket" {
#   description = "The bucket to store logs."
#   type        = string
# }

# variable "logging_log_object_prefix" {
#   description = "The object prefix for logs."
#   type        = string
# }

# variable "website_main_page_suffix" {
#   description = "The main page suffix for the website."
#   type        = string
# }

# variable "website_not_found_page" {
#   description = "The 404 page for the website."
#   type        = string
# }

variable "labels" {
  description = "Labels to apply to the bucket."
  type        = map(string)
}

variable "notification_topic" {
  description = "The Pub/Sub topic to notify when new objects are finalized in the bucket."
  type        = string
  default     = ""
}