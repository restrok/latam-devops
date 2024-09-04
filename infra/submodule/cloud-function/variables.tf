variable "name" {}
variable "runtime" {}
variable "entry_point" {}
variable "source_directory" {}
variable "trigger_http" {
  type    = bool
  default = false
}
variable "event_trigger_type" {}
variable "event_trigger_resource" {}
variable "environment_variables" {
  type    = map(string)
  default = {}
}