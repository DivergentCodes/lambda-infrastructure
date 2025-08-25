data "aws_caller_identity" "current" {}

########################################################
# Lambda function (zip)
########################################################

module "lambda_function" {
  count = var.deployment_type == "zip" ? 1 : 0

  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  architectures = [var.architecture]
  timeout       = var.timeout
  memory_size   = var.memory_size

  role_name = "${var.function_name}-exec"

  # Do not overwrite the new packages as they are deployed.
  ignore_source_code_hash = true

  # Initialize the lambda function with the bootstrap zip file.
  create_package = false
  s3_existing_package = {
    bucket = var.lambda_artifact_bucket_name
    key    = var.lambda_artifact_bootstrap_zip_path
  }

  # Required for controlled blue/green deployment.
  publish = true

  logging_application_log_level = var.log_level
  logging_system_log_level      = var.log_level
  logging_log_format            = "JSON"
}

resource "aws_lambda_alias" "zip_live" {
  count            = var.codedeploy_enabled && var.deployment_type == "zip" ? 1 : 0
  name             = "live"
  function_name    = module.lambda_function[0].lambda_function_name
  function_version = module.lambda_function[0].lambda_function_version
  description      = "Stable alias used by CodeDeploy for Zip"
}

########################################################
# Lambda function (docker)
########################################################

# https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest#lambda-functions-from-container-image-stored-on-aws-ecr
module "lambda_function_docker" {
  count = var.deployment_type == "docker" ? 1 : 0

  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  description   = var.function_description

  architectures = [var.architecture]
  memory_size   = var.memory_size
  timeout       = var.timeout

  role_name = "${var.function_name}-exec"

  create_package = false
  package_type   = "Image"
  image_uri      = var.ecr_image_uri

  environment_variables = var.environment_variables

  logging_application_log_level = var.log_level
  logging_system_log_level      = var.log_level
  logging_log_format            = "JSON"
}

resource "aws_lambda_alias" "docker_live" {
  count            = var.codedeploy_enabled && var.deployment_type == "docker" ? 1 : 0
  name             = "live"
  function_name    = module.lambda_function_docker[0].lambda_function_name
  function_version = module.lambda_function_docker[0].lambda_function_version
  description      = "Stable alias used by CodeDeploy for Docker"
}
