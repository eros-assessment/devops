variable "name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = null
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = null
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144
}


variable "redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "alarm_sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifactions"
  default     = null
}

variable "allowed_arns" {
  description = "A list of AWS account IDs allowed to access this resource"
  type        = list(any)
  default     = null
}

variable "allowed_items_max" {
  description = "The maximum number of items allowed on the SQS queue before it triggers an alarm"
  default     = 50
}

variable "max_task_receive_count" {
  description = "Maximum time a task should be retried before being pushed to DLQ"
  type        = number
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}