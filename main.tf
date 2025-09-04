terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Use a recent version
    }
  }
}

provider "aws" {
  region = "ap-south-1"  
}

module "s3_dev" {
  source        = "./Modules/s3-bucket"
  environment   = "dev"
}

module "s3_staging" {
  source        = "./Modules/s3-bucket"
  environment   = "staging"
}

module "s3_prod" {
  source        = "./Modules/s3-bucket"
  environment   = "prod"
}

# Optional: Output all bucket names
output "dev_bucket_name" {
  value = module.s3_dev.bucket_name
}

output "staging_bucket_name" {
  value = module.s3_staging.bucket_name
}

output "prod_bucket_name" {
  value = module.s3_prod.bucket_name
}