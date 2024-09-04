variable "name" {
  description = "The name of the bucket. Must be globally unique."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "uniform_bucket_level_access" {
  description = "Enables Uniform bucket-level access."
  type        = bool
  default     = true
}

variable "cors" {
  description = "The bucket's Cross-Origin Resource Sharing (CORS) configuration."
  type = list(object({
    max_age_seconds = number
    method          = list(string)
    origin          = list(string)
    response_header = list(string)
  }))
  default = []
}

variable "lifecycle_age" {
  description = "The age of the objects to be deleted by the lifecycle rule."
  type        = number
  default     = 365
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket."
  type        = bool
  default     = false
}

variable "logging_log_bucket" {
  description = "The bucket that will receive the logs."
  type        = string
  default     = ""
}

variable "logging_log_object_prefix" {
  description = "A prefix for log object names."
  type        = string
  default     = ""
}

variable "website_main_page_suffix" {
  description = "The suffix of the main page for the website."
  type        = string
  default     = ""
}

variable "website_not_found_page" {
  description = "The name of the 404 page for the website."
  type        = string
  default     = ""
}