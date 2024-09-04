terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

resource "google_storage_bucket" "bucket" {
  name                        = var.name
  location                    = var.location
  uniform_bucket_level_access = var.uniform_bucket_level_access

  cors {
    max_age_seconds           = var.cors.max_age_seconds
    method                   = var.cors.methods
    origin                  = var.cors.origins
    response_header       = var.cors.response_headers
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = var.lifecycle_age
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  logging {
    log_bucket        = var.logging_log_bucket
    log_object_prefix = var.logging_log_object_prefix
  }

  website {
    main_page_suffix = var.website_main_page_suffix
    not_found_page   = var.website_not_found_page
  }

  labels = var.labels
}

resource "google_storage_notification" "bucket_notification" {
  count  = var.notification_topic != "" ? 1 : 0
  bucket = google_storage_bucket.bucket.name
  topic  = var.notification_topic

  payload_format = "JSON_API_V1"

  event_types = [
    "OBJECT_FINALIZE",
  ]

  depends_on = [google_project_service.storage]
}