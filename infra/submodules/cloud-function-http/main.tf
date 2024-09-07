terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = ">= 4.34.0"
    }
  }
}

# resource "google_storage_bucket_object" "archive" {
#   for_each = var.functions

#   name   = "${each.value.name}.zip"
#   bucket = var.source_code_bucket
#   source = "../src/${each.value.name}.zip"
# }

resource "google_cloudfunctions_function" "function_http" {
  for_each = var.functions

  name                  = each.value.name
  runtime               = each.value.runtime
  entry_point           = each.value.entry_point
  source_archive_bucket = var.source_code_bucket
  # source_archive_object = google_storage_bucket_object.archive[each.key].name
  source_archive_object = "${each.value.name}-${var.version}.zip"
  trigger_http          = true
  environment_variables = each.value.environment_variables

  # Aquí irían otras configuraciones específicas para funciones HTTP...
}

output "http_function_urls" {
  value = {
    for name, function in google_cloudfunctions_function.function_http :
    name => function.https_trigger_url
  }
  description = "The HTTP trigger URLs for the HTTP-triggered Cloud Functions."
}