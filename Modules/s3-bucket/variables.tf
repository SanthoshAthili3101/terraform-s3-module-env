variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for the bucket name"
  type        = string
  default     = "santhosh-edu-bucket"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
