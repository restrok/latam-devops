variable "location" {
  description = "The location of the Cloud Build trigger."
  type        = string
}

variable "name" {
  description = "The name of the Cloud Build trigger."
  type        = string
}

variable "filename" {
  description = "The path to the Cloud Build configuration file."
  type        = string
}

variable "github_configurations" {
  description = "GitHub configuration block."
  type        = any
  default     = null
}