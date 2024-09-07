variable "source_code_bucket" {
  description = "The name of the bucket to store source code archives"
  type        = string
}

variable "functions" {
  description = "A map of cloud function definitions"
  type = map(object({
    name               = string
    runtime            = string
    entry_point        = string
    event_trigger_type = string
    # event_trigger_resource = string
    environment_variables = map(string)
  }))
}

variable "code_version" {}