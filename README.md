# lambda-infrastructure

Terraformed Lambda infrastructure, decoupled from Lambda app code

This repository has a Terraform module and a demonstration workspace that uses it.
The module creates a Lambda that is independent of future code deployments. Lambda
code can be released and deployed to the provisioned Lambda without Terraform runs
and without Terraform fighting for control.

Each Terraform function is bootstrapped with a minimal zip archive during provisioning.
Beyond that, they are not updated when new code versions are published. That is for the
sibbling `lambda-application` repository to handle, with CodeDeploy blue/green releases.

## Resources

- [terraform-aws-modules](https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest#lambda-function-or-lambda-layer-with-the-deployable-artifact-maintained-separately-from-the-infrastructure)
