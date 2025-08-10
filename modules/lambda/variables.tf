variable "region" {
  type = string
}

variable "function_name" {
  type = string
}

########################################################
# Compute
########################################################

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
# Bootstrap code
########################################################

variable "bootstrap_bucket_name" {
  description = "The bucket with the bootstrap zip file to bootstrap the lambda function"
  type        = string
}

variable "bootstrap_bucket_zip_path" {
  description = "The path to the bootstrap zip file in the bootstrap bucket"
  type        = string
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
