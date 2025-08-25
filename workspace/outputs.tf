output "lambda_application_zip_function_name" {
  value = var.lambda_deployment_type == "zip" ? module.lambda_application_zip[0].function_name : null
}

output "lambda_application_zip_function_arn" {
  value = var.lambda_deployment_type == "zip" ? module.lambda_application_zip[0].function_arn : null
}

output "artifact_bucket_name" {
  value = var.lambda_deployment_type == "zip" ? aws_s3_bucket.artifact_bucket[0].id : null
}

output "artifact_bucket_arn" {
  value = var.lambda_deployment_type == "zip" ? aws_s3_bucket.artifact_bucket[0].arn : null
}

output "ecr_repository_name" {
  value = var.lambda_deployment_type == "docker" ? aws_ecr_repository.lambda_application[0].name : null
}

output "ecr_repository_arn" {
  value = var.lambda_deployment_type == "docker" ? aws_ecr_repository.lambda_application[0].arn : null
}

output "ecr_repository_url" {
  value = var.lambda_deployment_type == "docker" ? aws_ecr_repository.lambda_application[0].repository_url : null
}

output "github_oidc_role_name" {
  value = var.lambda_deployment_type == "docker" ? aws_iam_role.github_actions_oidc_role[0].name : null
}

output "github_oidc_role_arn" {
  value = var.lambda_deployment_type == "docker" ? aws_iam_role.github_actions_oidc_role[0].arn : null
}

output "github_release_workflow_file" {
  value = var.github_release_workflow_file != "" ? var.github_release_workflow_file : null
}
