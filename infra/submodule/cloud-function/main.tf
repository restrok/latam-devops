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

  dynamic "cors" {
    for_each = var.cors
    content {
      max_age_seconds = cors.value.max_age_seconds
      method          = cors.value.method
      origin          = cors.value.origin
      response_header = cors.value.response_header
    }
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
}

# output "name" {
#   value = google_storage_bucket.bucket.name
# }