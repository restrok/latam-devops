variable "topic_name" {
  description = "The name of the Pub/Sub topic."
  type        = string
}

variable "subscription_name" {
  description = "The name of the Pub/Sub subscription."
  type        = string
}

variable "ack_deadline_seconds" {
  description = "The maximum time after a subscriber receives a message before the subscriber should acknowledge the message."
  type        = number
  default     = 10
}

variable "retain_acked_messages" {
  description = "Indicates whether to retain acknowledged messages. If true, acknowledged messages are not expunged until they fall out of the message retention window."
  type        = bool
  default     = false
}

variable "message_retention_duration" {
  description = "How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published."
  type        = string
  default     = "604800s" # 7 days
}

variable "push_endpoint" {
  description = "A URL locating the endpoint to which messages should be pushed."
  type        = string
}