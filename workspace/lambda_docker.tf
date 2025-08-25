########################################################
# Lambda Docker
########################################################

locals {
  default_ecr_image_tag = "0.3.0"
  ecr_image_tag         = var.lambda_ecr_image_tag != "" ? var.lambda_ecr_image_tag : local.default_ecr_image_tag
}

module "lambda_application_docker" {
  count = var.lambda_deployment_type == "docker" ? 1 : 0

  source = "../modules/lambda"

  region               = var.region
  function_name        = "lambda-docker-${random_string.suffix.result}"
  function_description = "Demo function for split application & infrastructure"
  handler              = "index.handler"
  runtime              = "python3.12"
  architecture         = "x86_64"

  github_owner       = var.github_owner
  github_repo        = var.github_repo
  github_environment = var.github_environment
  github_region      = var.github_region

  deployment_type = var.lambda_deployment_type
  ecr_image_uri   = "${aws_ecr_repository.lambda_application[0].repository_url}:${local.ecr_image_tag}"
}
