output "function_arn" {
  description = "ARN of the Lambda function"
  value       = var.deployment_type == "zip" ? module.lambda_function[0].lambda_function_arn : module.lambda_function_docker[0].lambda_function_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = var.deployment_type == "zip" ? module.lambda_function[0].lambda_function_name : module.lambda_function_docker[0].lambda_function_name
}

output "function_qualified_arn" {
  description = "ARN identifying your Lambda Function Version"
  value       = var.deployment_type == "zip" ? module.lambda_function[0].lambda_function_qualified_arn : module.lambda_function_docker[0].lambda_function_qualified_arn
}

output "function_qualified_invoke_arn" {
  description = "Qualified ARN (ARN with version) to be used for invoking the Lambda Function"
  value       = var.deployment_type == "zip" ? module.lambda_function[0].lambda_function_invoke_arn : module.lambda_function_docker[0].lambda_function_invoke_arn
}
