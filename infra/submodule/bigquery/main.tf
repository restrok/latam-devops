terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  project    = var.project_id
  location   = var.location

  labels = var.labels
}

resource "google_bigquery_table" "table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.table_id
  project    = var.project_id

  schema     = file(var.schema_path)
  time_partitioning {
    type = var.time_partitioning_type
  }
}

# output "dataset_id" {
#   value = google_bigquery_dataset.dataset.dataset_id
# }

# output "table_id" {
#   value = google_bigquery_table.table.table_id
# }