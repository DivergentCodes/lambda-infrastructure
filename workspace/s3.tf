########################################################
# Artifact Bucket
########################################################

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "lambda-artifacts-${var.region}-${random_string.bucket_suffix.result}"
}

# Enable versioning for artifact recovery
resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket_encryption" {
  bucket = aws_s3_bucket.artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "artifact_bucket_public_access_block" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy to deny non-SSL requests
resource "aws_s3_bucket_policy" "artifact_bucket_policy" {
  bucket     = aws_s3_bucket.artifact_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.artifact_bucket_public_access_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyNonSSLRequests"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.artifact_bucket.arn,
          "${aws_s3_bucket.artifact_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AllowLambdaServiceAccess"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.artifact_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Lifecycle rules for artifact management
resource "aws_s3_bucket_lifecycle_configuration" "artifact_bucket_lifecycle" {
  bucket = aws_s3_bucket.artifact_bucket.id

  rule {
    id     = "artifact_cleanup"
    status = "Enabled"

    # Required filter - applies to all objects
    filter {
      prefix = ""
    }

    # Delete old versions after 30 days
    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    # Delete incomplete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # Transition to cheaper storage after 30 days (minimum for STANDARD_IA)
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Archive to Glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Delete objects after 1 year
    expiration {
      days = 365
    }
  }
}

# Enable access logging for audit
resource "aws_s3_bucket_logging" "artifact_bucket_logging" {
  bucket = aws_s3_bucket.artifact_bucket.id

  target_bucket = aws_s3_bucket.artifact_bucket.id
  target_prefix = "logs/"
}
