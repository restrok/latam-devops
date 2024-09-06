terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = ">= 4.34.0"
    }
  }
}

resource "google_storage_bucket_object" "archive" {
  for_each = var.functions

  name   = "${each.value.name}.zip"
  bucket = var.source_code_bucket
  source = "../src/${each.value.name}.zip"
}

resource "google_pubsub_topic" "topic" {
  for_each = var.functions

  name = each.value.name
}

resource "google_cloudfunctions_function" "function_event" {
  for_each = var.functions

  name                  = each.value.name
  runtime               = each.value.runtime
  entry_point           = each.value.entry_point
  source_archive_bucket = var.source_code_bucket
  source_archive_object = google_storage_bucket_object.archive[each.key].name
  event_trigger {
    event_type = each.value.event_trigger_type
    resource   = google_pubsub_topic.topic[each.key].id
  }
  environment_variables = each.value.environment_variables

  # Aquí irían otras configuraciones específicas para funciones de evento...
}