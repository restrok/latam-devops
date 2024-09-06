project_id     = "latam-test-434700"
region         = "us-central1"
project_prefix = "latam_test"


buckets = {
  function_code = {
    name                        = "function-code-bucket"
    uniform_bucket_level_access = true
    cors                        = []
    lifecycle_age               = 365
    versioning_enabled          = false
    logging_log_bucket          = ""
    logging_log_object_prefix   = ""
    website_main_page_suffix    = ""
    website_not_found_page      = ""
    notification_topic          = ""
  }
  ingest_data = {
    name                        = "ingest-data-bucket"
    uniform_bucket_level_access = true
    cors                        = []
    lifecycle_age               = 365
    versioning_enabled          = false
    logging_log_bucket          = ""
    logging_log_object_prefix   = ""
    website_main_page_suffix    = ""
    website_not_found_page      = ""
    notification_topic          = "projects/latam-test-434700/topics/process_data_to_bigquery"
  }
  terraform_state = {
    name                        = "terraform-state-bucket"
    uniform_bucket_level_access = true
    cors                        = []
    lifecycle_age               = 365
    versioning_enabled          = false
    logging_log_bucket          = ""
    logging_log_object_prefix   = ""
    website_main_page_suffix    = ""
    website_not_found_page      = ""
    notification_topic          = ""
  }
}

cloud_functions_http = {
  ingest_data_to_bucket = {
    name                   = "ingest_data_to_bucket"
    runtime                = "python39"
    entry_point            = "upload_data"
    trigger_http           = true
    event_trigger_type     = ""
    event_trigger_resource = ""
    environment_variables = {
      BUCKET_NAME = "ingest-data-bucket-latam_test"
    }
  }
  get_data_from_bigquery = {
    name                   = "get_data_from_bigquery"
    runtime                = "python39"
    entry_point            = "get_data"
    trigger_http           = true
    event_trigger_type     = ""
    event_trigger_resource = ""
    environment_variables = {
      DATASET_ID = "latam_test_dataset"
      TABLE_ID   = "latam_test_table"
    }
  }
}

cloud_functions_event = {
  process_data_to_bigquery = {
    name               = "process_data_to_bigquery"
    runtime            = "python39"
    entry_point        = "process_pubsub_event"
    trigger_http       = false
    event_trigger_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    environment_variables = {
      BUCKET_NAME = "ingest-data-bucket-latam_test"
      DATASET_ID  = "latam_test_dataset"
      TABLE_ID    = "latam_test_table"
    }
  }
}

schema_path            = "schema.json"
labels                 = {}
time_partitioning_type = "DAY"


cloudbuild-config = {
  cd-plan = {
    filename = "tf-plan.yaml"
    github_configurations = {
      name  = "latam-devops"
      owner = "github"
      branch = "^develop$"
    }
  }
  cd-apply = {

    filename = "tf-apply.yaml"
    github_configurations = {
      name  = "latam-devops"
      owner = "restrok"
      branch = "^master$"
    }
  }
  # ci-build = {
  #   repo     = "latam-devops"
  #   owner    = "restrok"
  #   filename = "cf-build.yaml"
  #   github_configurations = false
  # }
}