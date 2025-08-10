# Get current AWS account ID for policy
data "aws_caller_identity" "current" {}

locals {
  s3_path_lambda_bootstrap_zip_basic = "lambda-bootstrap/basic.zip"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

########################################################
# Lambda Bootstrap Archive
########################################################

# Create zip archive from Python source code
data "archive_file" "lambda_bootstrap_zip" {
  type        = "zip"
  source_dir  = "./lambda-bootstrap/basic"
  output_path = "./lambda-bootstrap/basic.zip"
  excludes    = ["*.tf", "*.tfvars", "*.zip"]
}

resource "aws_s3_object" "lambda_bootstrap_zip_basic" {
  bucket = aws_s3_bucket.artifact_bucket.id
  key    = local.s3_path_lambda_bootstrap_zip_basic
  source = data.archive_file.lambda_bootstrap_zip.output_path

  depends_on = [data.archive_file.lambda_bootstrap_zip]
}

########################################################
# Lambda Basic
########################################################

module "basic_lambda" {
  source = "../modules/lambda"

  region        = var.region
  function_name = "lambda-basic-${random_string.suffix.result}"
  handler       = "index.handler"
  runtime       = "python3.12"

  bootstrap_bucket_name     = aws_s3_bucket.artifact_bucket.id
  bootstrap_bucket_zip_path = local.s3_path_lambda_bootstrap_zip_basic
}
