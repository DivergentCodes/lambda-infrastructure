########################################################
# Lambda Zip
########################################################

module "lambda_application_zip" {
  count = var.lambda_deployment_type == "zip" ? 1 : 0

  source = "../modules/lambda"

  region               = var.region
  function_name        = "lambda-zip-${random_string.suffix.result}"
  function_description = "Demo function for split application & infrastructure"
  handler              = "index.handler"
  runtime              = "python3.12"

  github_owner       = var.github_owner
  github_repo        = var.github_repo
  github_environment = var.github_environment
  github_region      = var.github_region
}
