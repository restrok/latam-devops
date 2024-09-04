project_id   = "your-project-id"
region       = "your-region"
bucket_name  = "your-bucket-name"
dataset_id   = "your-dataset-id"
table_id     = "your-table-id"
pubsub_topic = "your-pubsub-topic"

cloud_functions = {
  upload_data = {
    name               = "upload_data"
    runtime            = "python39"
    entry_point        = "upload_data"
    source_directory   = "../path/to/your/source/directory/ingest_data_to_bucket"
    trigger_http       = true
    event_trigger_type = ""
    event_trigger_resource = ""
    environment_variables = {
      BUCKET_NAME = "your-bucket-name"
    }
  }
  process_data = {
    name               = "process_data"
    runtime            = "python39"
    entry_point        = "process_pubsub_event"
    source_directory   = "../path/to/your/source/directory/process_data_to_bigquery"
    trigger_http       = false
    event_trigger_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    event_trigger_resource = "projects/your-project-id/topics/your-pubsub-topic"
    environment_variables = {
      BUCKET_NAME = "your-bucket-name"
      DATASET_ID  = "your-dataset-id"
      TABLE_ID    = "your-table-id"
    }
  }
  get_data = {
    name               = "get_data"
    runtime            = "python39"
    entry_point        = "get_data"
    source_directory   = "../path/to/your/source/directory/get_data_from_bigquery"
    trigger_http       = true
    event_trigger_type = ""
    event_trigger_resource = ""
    environment_variables = {
      DATASET_ID = "your-dataset-id"
      TABLE_ID   = "your-table-id"
    }
  }
}