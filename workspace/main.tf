# Get current AWS account ID for policy
data "aws_caller_identity" "current" {}

locals {
  s3_lambda_artifact_bucket_name        = "lambda-artifacts-${var.region}-${random_string.suffix.result}"
  s3_lambda_artifact_base_path          = "lambda-bootstrap"
  s3_lambda_artifact_bootstrap_zip_path = "${local.s3_lambda_artifact_base_path}/basic.zip"
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
  key    = local.s3_lambda_artifact_bootstrap_zip_path
  source = data.archive_file.lambda_bootstrap_zip.output_path

  depends_on = [data.archive_file.lambda_bootstrap_zip]
}

########################################################
# Lambda Basic
########################################################

module "basic_lambda" {
  source = "../modules/lambda"

  region               = var.region
  function_name        = "lambda-basic-${random_string.suffix.result}"
  function_description = "Demo function for split application & infrastructure"
  handler              = "index.handler"
  runtime              = "python3.12"

  lambda_artifact_bucket_name        = aws_s3_bucket.artifact_bucket.id
  lambda_artifact_base_path          = local.s3_lambda_artifact_base_path
  lambda_artifact_bootstrap_zip_path = local.s3_lambda_artifact_bootstrap_zip_path
}
