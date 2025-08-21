output "function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda_function.lambda_function_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_function.lambda_function_name
}

output "function_qualified_arn" {
  description = "ARN identifying your Lambda Function Version"
  value       = module.lambda_function.lambda_function_qualified_arn
}

output "function_qualified_invoke_arn" {
  description = "Qualified ARN (ARN with version) to be used for invoking the Lambda Function"
  value       = module.lambda_function.lambda_function_invoke_arn
}
