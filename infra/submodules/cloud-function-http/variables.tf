variable "source_code_bucket" {
  description = "The name of the bucket to store source code archives"
  type        = string
}

variable "functions" {
  description = "A map of cloud function definitions for HTTP-triggered functions"
  type = map(object({
    name                  = string
    runtime               = string
    entry_point           = string
    environment_variables = map(string)
  }))
}

variable "version" {}