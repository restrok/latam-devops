variable "project_id" {
  description = "The ID of the project in which to create the dataset and table."
  type        = string
}

variable "location" {
  description = "The location of the dataset."
  type        = string
}

variable "dataset_id" {
  description = "The ID of the dataset to create."
  type        = string
}

variable "table_id" {
  description = "The ID of the table to create."
  type        = string
}

variable "schema_path" {
  description = "The path to the JSON schema file for the table."
  type        = string
}

variable "labels" {
  description = "A mapping of labels to assign to the dataset."
  type        = map(string)
  default     = {}
}

variable "time_partitioning_type" {
  description = "The type of time partitioning to apply to the table."
  type        = string
  default     = "DAY"
}