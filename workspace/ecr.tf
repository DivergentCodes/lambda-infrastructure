locals {
  github_oidc_role_name = "gha-${var.github_owner}-${var.github_repo}-${var.github_environment}"
}

########################################################
# ECR Repository
########################################################

resource "aws_ecr_repository" "lambda_application" {
  count = var.lambda_deployment_type == "docker" ? 1 : 0
  name  = var.ecr_repository_name

  image_tag_mutability = "IMMUTABLE"
  force_delete         = var.ecr_repository_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

########################################################
# GitHub OIDC Role
########################################################

# Policy for Github Actions to assume the role.
data "aws_iam_policy_document" "github_actions_oidc_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:TagSession"
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Match target repo and environment.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:environment:${var.github_environment}"]
    }
  }
}

resource "aws_iam_role" "github_actions_oidc_role" {
  count = var.lambda_deployment_type == "docker" ? 1 : 0
  name  = local.github_oidc_role_name

  assume_role_policy   = data.aws_iam_policy_document.github_actions_oidc_role.json
  max_session_duration = 3600
}

# Least-privilege ECR push policy for a single repo
resource "aws_iam_policy" "ecr_push" {
  count       = var.lambda_deployment_type == "docker" ? 1 : 0
  name        = "${local.github_oidc_role_name}-ecr-push"
  description = "Minimal ECR push for ${var.ecr_repository_name}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "ECRGetAuthorizationToken",
        Effect : "Allow",
        Action : [
          "ecr:GetAuthorizationToken"
        ],
        Resource : "*"
      },
      {
        Sid : "PushPullRepo",
        Effect : "Allow",
        Action : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ],
        Resource : "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.lambda_deployment_type == "docker" ? 1 : 0
  role       = aws_iam_role.github_actions_oidc_role[0].name
  policy_arn = aws_iam_policy.ecr_push[0].arn
}
