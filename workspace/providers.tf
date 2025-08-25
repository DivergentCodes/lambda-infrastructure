provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project     = "lambda-infrastructure"
      environment = "demo"
      repository  = "https://github.com/DivergentCodes/lambda-infrastructure"
    }
  }
}
