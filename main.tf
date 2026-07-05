terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.53.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "infra" {
  bucket = "my-tf-140023390772-bucket"
}

resource "aws_s3_bucket_ownership_controls" "infra" {
  bucket = aws_s3_bucket.infra.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "infra" {
  depends_on = [aws_s3_bucket_ownership_controls.infra]

  bucket = aws_s3_bucket.infra.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "infra" {
  bucket = aws_s3_bucket.infra.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "infra" {
  bucket = aws_s3_bucket.infra.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "infra" {
  bucket = aws_s3_bucket.infra.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "alias/aws/s3"
    }
  }
}
