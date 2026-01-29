variable "region" {
  description = "AWS region to deploy networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet and Lambda runs here"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}