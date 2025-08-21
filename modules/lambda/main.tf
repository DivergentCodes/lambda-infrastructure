########################################################
# Lambda function
########################################################

module "lambda_function" {
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
}

########################################################
# Lambda alias
########################################################

# Stable alias that CodeDeploy will shift between function versions
resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = module.lambda_function.lambda_function_name
  function_version = module.lambda_function.lambda_function_version
  description      = "Stable alias used by CodeDeploy"
}
