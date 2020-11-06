provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-1"
}

resource "aws_s3_bucket" "otus-project-infra" {
  bucket = "otus-project-infra-tfstate"
  acl    = "private"

  tags = {
    Name        = "Backend Terraform otus-project"
    Environment = "otus-project"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}