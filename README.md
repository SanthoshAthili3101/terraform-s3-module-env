Terraform Module: AWS S3 Bucket Creator
This Terraform module provides a reusable way to provision AWS S3 buckets with environment-specific naming (e.g., dev, staging, prod). It incorporates randomness to ensure globally unique bucket names, avoiding common AWS conflicts. The module is designed for modularity, allowing you to create multiple buckets across environments without code duplication.

Overview
Purpose: Creates an S3 bucket with customizable prefixes, environments, and tags. Uses the random_id resource to append a unique suffix for name uniqueness.

Key Features:

Environment-based naming (e.g., "my-app-dev-abc123").

Optional tags for organization.

Outputs for bucket name and ARN.

Use Case: Ideal for multi-environment setups (dev, staging, prod) in CI/CD pipelines or infrastructure as code projects.

This module is based on HashiCorp's best practices and can be extended with policies, versioning, or lifecycle rules.

Requirements
Name	Version
Terraform	>= 1.0
AWS Provider	>= 5.0
Random Provider	>= 3.0
AWS account with credentials configured (e.g., via aws configure or environment variables).

Ensure your AWS IAM user has permissions for S3 bucket creation (e.g., s3:CreateBucket).

Providers
This module uses the following providers (defined in the root configuration):

text
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
Module Structure
The module files are located in ./modules/s3-bucket/:

main.tf: Defines the AWS provider, random ID, and S3 bucket resource.

variables.tf: Input variables for customization.

outputs.tf: Exposes bucket details for use in root configurations.

Usage
Clone or Set Up the Repository:

Create a root directory with a main.tf that calls this module.

Place the module in ./modules/s3-bucket/.

Call the Module in Your Root main.tf:

Example for creating buckets for dev, staging, and prod:

text
provider "aws" {
  region = "us-east-1"  # Adjust to your preferred region
}

module "s3_dev" {
  source        = "./modules/s3-bucket"
  environment   = "dev"
  bucket_prefix = "my-app"
  region        = "us-east-1"
}

module "s3_staging" {
  source        = "./modules/s3-bucket"
  environment   = "staging"
  bucket_prefix = "my-app"
  region        = "us-east-1"
}

module "s3_prod" {
  source        = "./modules/s3-bucket"
  environment   = "prod"
  bucket_prefix = "my-app"
  region        = "us-east-1"
}

# Outputs for verification
output "dev_bucket_name" {
  value = module.s3_dev.bucket_name
}

output "staging_bucket_name" {
  value = module.s3_staging.bucket_name
}

output "prod_bucket_name" {
  value = module.s3_prod.bucket_name
}
Run Terraform Commands (in the root directory):

terraform init: Initialize providers and modules.

terraform plan: Preview changes (e.g., creating three unique buckets).

terraform apply: Provision the buckets (confirm with "yes").

terraform destroy: Clean up to avoid AWS costs.

Verification:

After apply, check outputs for bucket names (e.g., "my-app-dev-1a2b3c4d").

Log in to the AWS S3 console to confirm the buckets exist.

Inputs
Name	Description	Type	Default	Required
environment	Environment name (e.g., dev, staging, prod) appended to the bucket name.	string	N/A	Yes
bucket_prefix	Prefix for the bucket name (e.g., "my-app").	string	"my-app-bucket"	No
region	AWS region for the bucket.	string	"us-east-1"	No
Outputs
Name	Description
bucket_name	The generated name of the S3 bucket (e.g., "my-app-dev-abc123").
bucket_arn	The ARN of the S3 bucket.
Examples
Basic Example (Single Bucket)
text
module "s3_test" {
  source        = "./modules/s3-bucket"
  environment   = "test"
  bucket_prefix = "test-app"
}
Advanced Example (With Custom Tags and Versioning)
Extend the module's main.tf to add features like versioning:

text
resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_prefix}-${var.environment}-${random_id.suffix.hex}"
  
  versioning {
    enabled = true
  }
  
  tags = {
    Environment = var.environment
    Project     = "MyProject"
  }
}
