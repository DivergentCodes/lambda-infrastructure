variable "region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_deployment_type" {
  description = "The type of deployment for the lambda function. Must be one of: zip, docker."
  type        = string
  default     = "docker"

  validation {
    condition     = contains(["zip", "docker"], var.lambda_deployment_type)
    error_message = "Invalid lambda deployment type. Must be one of: zip, docker."
  }
}

variable "lambda_ecr_image_tag" {
  description = "The tag of the ECR image."
  type        = string
  default     = ""
}

variable "github_create_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider."
  type        = bool
  default     = false
}

variable "github_oidc_thumbprint_list" {
  description = "The list of thumbprints for the GitHub OIDC provider."
  type        = list(string)

  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

variable "github_owner" {
  description = "The owner of the GitHub repository."
  type        = string
  default     = "DivergentCodes"
}
variable "github_repo" {
  description = "The name of the GitHub repository."
  type        = string
  default     = "lambda-application"
}

variable "github_release_workflow_file" {
  description = "The path to the GitHub release workflow file."
  type        = string
  default     = ".github/workflows/release.yml"
}

variable "github_environment" {
  description = "The environment of the GitHub repository."
  type        = string
  default     = "release-ecr"
}

variable "github_region" {
  description = "The region of the GitHub repository."
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  type    = string
  default = "lambda-application"
}

variable "ecr_repository_force_delete" {
  type    = bool
  default = true
}
