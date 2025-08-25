variable "region" {
  type = string
}

variable "function_name" {
  type = string
}

variable "function_description" {
  type = string
}

variable "deployment_type" {
  type    = string
  default = "docker"
  validation {
    condition     = contains(["docker", "zip"], var.deployment_type)
    error_message = "Invalid deployment type. Must be one of: docker, zip."
  }
}

########################################################
# GitHub
########################################################

variable "github_owner" {
  description = "The owner of the GitHub repository."
  type        = string
  default     = ""
}
variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
  default     = ""
}

variable "github_environment" {
  description = "The environment of the GitHub repository."
  type        = string
  default     = ""
}

variable "github_region" {
  description = "The region of the GitHub repository."
  type        = string
  default     = ""
}

########################################################
# Compute
########################################################

variable "environment_variables" {
  description = "The environment variables for the lambda function"
  type        = map(string)
  default     = {}
}

variable "architecture" {
  description = "The architecture of the lambda function"
  type        = string
  default     = "x86_64"
}

variable "runtime" {
  type = string
}

variable "handler" {
  type = string
}

variable "timeout" {
  type    = number
  default = 300
}

variable "memory_size" {
  type    = number
  default = 128
}

########################################################
# S3 artifact bucket
########################################################

variable "lambda_artifact_bucket_name" {
  description = "The bucket with the Lambda artifacts"
  type        = string
  default     = ""
}

variable "lambda_artifact_base_path" {
  description = "The S3 base path to the Lambda artifacts in the artifact bucket"
  type        = string
  default     = ""
}

variable "lambda_artifact_bootstrap_zip_path" {
  description = "The S3 path to the bootstrap zip file in the artifact bucket"
  type        = string
  default     = ""
}

########################################################
# ECR
########################################################

variable "ecr_image_uri" {
  description = "The URI of the ECR image."
  type        = string
  default     = null
}

########################################################
# Logging
########################################################

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain the logs in the cloudwatch log group"
  type        = number
  default     = 30
}

variable "log_level" {
  description = "The log level to use for the cloudwatch log group"
  type        = string
  default     = "INFO"
}

########################################################
# CodeDeploy
########################################################

variable "codedeploy_enabled" {
  description = "Whether to use CodeDeploy for the Lambda function"
  type        = bool
  default     = false
}
