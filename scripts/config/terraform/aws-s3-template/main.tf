terraform {
  required_version = ">= 1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "app" {
  count         = var.bucket_count
  bucket        = "${var.bucket_prefix}-${format("%03d", count.index)}-cloudlab"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "app" {
  count  = var.bucket_count
  bucket = aws_s3_bucket.app[count.index].id

  rule {
    id = "Delete objects after 1 day"
    expiration {
      days = 1
    }
    filter {}
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  count  = var.bucket_count
  bucket = aws_s3_bucket.app[count.index].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "app" {
  depends_on = [
    aws_s3_bucket_public_access_block.app,
    aws_s3_bucket_ownership_controls.app,
  ]
  count  = var.bucket_count
  bucket = aws_s3_bucket.app[count.index].id

  acl    = "public-read"
}

resource "aws_s3_bucket_ownership_controls" "app" {
  count  = var.bucket_count
  bucket = aws_s3_bucket.app[count.index].id
  rule {
    object_ownership = "ObjectWriter"
  }
}
