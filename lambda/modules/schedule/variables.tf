variable "environment" {
  description = "Deployment environment label"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda to trigger"
  type        = string
}

variable "cron_schedule" {
  description = "Cron expression for the schedule"
  type        = string
}