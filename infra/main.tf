module "storage" {
  source = "./submodules/cloud-storage"

  for_each = var.buckets

  name                        = "${each.value.name}-${var.project_prefix}"
  location                    = var.region
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  lifecycle_age               = each.value.lifecycle_age
  versioning_enabled          = each.value.versioning_enabled
  # logging_log_bucket          = each.value.logging_log_bucket
  # logging_log_object_prefix   = each.value.logging_log_object_prefix
  # website_main_page_suffix    = each.value.website_main_page_suffix
  # website_not_found_page      = each.value.website_not_found_page
  notification_topic = each.value.notification_topic
  labels             = var.labels
}

module "http_functions" {
  source = "./submodules/cloud-function-http"

  functions          = var.cloud_functions_http
  source_code_bucket = "function-code-bucket-${var.project_prefix}"
  code_version       = var.build_version

  depends_on = [module.storage]
}

module "event_functions" {
  source = "./submodules/cloud-function-event"

  functions          = var.cloud_functions_event
  source_code_bucket = "function-code-bucket-${var.project_prefix}"
  code_version       = var.build_version

  depends_on = [module.storage]
}

module "api_gateway" {
  source          = "./submodules/api-gateway"
  project_id      = var.project_id
  region          = var.region
  api_name        = "my-api"
  api_config_name = "my-api-config"
  gateway_name    = "my-gateway"
  functions = {
    upload_data = module.http_functions.http_function_urls["ingest_data_to_bucket"]
    get_data    = module.http_functions.http_function_urls["get_data_from_bigquery"]
  }
  # openapi_template_path = "${path.module}/openapi.yaml.tpl"
}

module "bigquery" {
  source = "./submodules/bigquery"

  project_id             = var.project_id
  location               = var.region
  dataset_id             = "${var.project_prefix}_dataset"
  table_id               = "${var.project_prefix}_table"
  schema_path            = var.schema_path
  labels                 = var.labels
  time_partitioning_type = var.time_partitioning_type
}

module "cloudbuild_trigger" {
  source = "./submodules/cloudbuild-trigger"

  for_each = var.cloudbuild-config

  region            = var.region
  name              = each.key
  cloudbuild-config = each.value
  project_id        = var.project_id
}