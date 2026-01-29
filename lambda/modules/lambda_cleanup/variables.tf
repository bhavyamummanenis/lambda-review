variable "region" {
  description = "AWS region for Lambda"
  type        = string
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Lambda vpc_config"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for Lambda vpc_config"
  type        = list(string)
}

variable "age_days" {
  description = "Number of days where snapshots older than this will be deleted"
  type        = number
  default     = 365
}

variable "deployment_package" {
  description = "Path to the Lambda deployment zip file"
  type        = string
}

variable "timeout" {
  description = "Lambda timeout value in seconds"
  type        = number
  default     = 300
}

variable "memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}