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
# GitHub OIDC Provider
########################################################

resource "aws_iam_openid_connect_provider" "github" {
  count           = var.github_create_oidc_provider ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.github_oidc_thumbprint_list
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

########################################################
# Lambda Basic
########################################################

module "lambda_application_zip" {
  count = var.lambda_deployment_type == "zip" ? 1 : 0

  source = "../modules/lambda"

  region               = var.region
  function_name        = "lambda-basic-${random_string.suffix.result}"
  function_description = "Demo function for split application & infrastructure"
  handler              = "index.handler"
  runtime              = "python3.12"

  github_owner       = var.github_owner
  github_repo        = var.github_repo
  github_environment = var.github_environment
  github_region      = var.github_region

  ecr_repository_name = var.ecr_repository_name
}
