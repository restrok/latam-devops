terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

resource "google_pubsub_topic" "topic" {
  name = var.topic_name
}

resource "google_pubsub_subscription" "subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.topic.id

  ack_deadline_seconds = var.ack_deadline_seconds
  retain_acked_messages = var.retain_acked_messages
  message_retention_duration = var.message_retention_duration

  push_config {
    push_endpoint = var.push_endpoint
  }
}

output "topic_id" {
  value = google_pubsub_topic.topic.id
}

output "subscription_id" {
  value = google_pubsub_subscription.subscription.id
}