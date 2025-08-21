########################################################
# CodeDeploy service role for Lambda
########################################################

resource "aws_iam_role" "codedeploy" {
  name               = "${var.function_name}-codedeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_trust.json
}

data "aws_iam_policy_document" "codedeploy_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_managed" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
}

########################################################
# CodeDeploy application and deployment group
########################################################

resource "aws_codedeploy_app" "lambda" {
  name             = "${var.function_name}-app"
  compute_platform = "Lambda"
}

resource "aws_codedeploy_deployment_group" "lambda" {
  app_name              = aws_codedeploy_app.lambda.name
  deployment_group_name = "${var.function_name}-dgroup"
  service_role_arn      = aws_iam_role.codedeploy.arn

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  # Built-in canary: shift 10% for 5 minutes, then 100%
  deployment_config_name = "CodeDeployDefault.LambdaCanary10Percent5Minutes"

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
      "DEPLOYMENT_STOP_ON_ALARM",
    ]
  }
}
