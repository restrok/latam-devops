terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name                        = each.value.name
  location                    = each.value.location
  uniform_bucket_level_access = each.value.uniform_bucket_level_access

  dynamic "cors" {
    for_each = each.value.cors
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
      age = each.value.lifecycle_age
    }
  }

  versioning {
    enabled = each.value.versioning_enabled
  }

  logging {
    log_bucket        = each.value.logging_log_bucket
    log_object_prefix = each.value.logging_log_object_prefix
  }

  website {
    main_page_suffix = each.value.website_main_page_suffix
    not_found_page   = each.value.website_not_found_page
  }
}

output "bucket_names" {
  value = { for k, v in google_storage_bucket.buckets : k => v.name }
}