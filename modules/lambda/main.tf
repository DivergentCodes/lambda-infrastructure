module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  architectures = [var.architecture]
  timeout       = var.timeout
  memory_size   = var.memory_size


  create_package          = false
  ignore_source_code_hash = true
  s3_existing_package = {
    bucket = var.bootstrap_bucket_name
    key    = var.bootstrap_bucket_zip_path
  }

  logging_application_log_level = var.log_level
  logging_system_log_level      = var.log_level

  # Required for controlled blue/green deployment
  publish = true
}
