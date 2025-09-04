provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_prefix}-${var.environment}"
  
  # Optional: Add tags for identification
  tags = {
    Environment = var.environment
  }
}
