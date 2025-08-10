output "basic_lambda_function_name" {
  value = module.basic_lambda.function_name
}

output "basic_lambda_function_arn" {
  value = module.basic_lambda.function_arn
}

output "artifact_bucket_name" {
  value = aws_s3_bucket.artifact_bucket.id
}

output "artifact_bucket_arn" {
  value = aws_s3_bucket.artifact_bucket.arn
}
