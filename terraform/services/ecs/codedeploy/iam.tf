data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_by_codedeploy" {
  statement {
    sid     = "AssumeRoleForCodeDeploy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codedeploy" {
  statement {
    sid    = "AllowLoadBalancingAndECSModifications"
    effect = "Allow"

    actions = [
      "ecs:CreateTaskSet",
      "ecs:DeleteTaskSet",
      "ecs:DescribeServices",
      "ecs:UpdateServicePrimaryTaskSet",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule"
    ]

    resources = [
      "*",
    ]
  }
  statement {
    sid    = "AllowPassRole"
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = [
      "*" #TODO
    ]
  }

  statement {
    sid    = "DeployService"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "codedeploy:GetDeploymentGroup",
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = [
      "*"
      # #TODO    var.ecs_service_id,
      #   aws_CODEDEPLOY_DEPLOYMENT_GROUP_API.this.arn,
      #   "arn:aws:codedeploy:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:deploymentconfig:*}",
      #   aws_codedeploy_app.this.arn
    ]
  }


}


resource "aws_iam_role" "codedeploy" {
  name               = "${local.name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_by_codedeploy.json
}

resource "aws_iam_role_policy" "codedeploy" {
  role   = aws_iam_role.codedeploy.name
  policy = data.aws_iam_policy_document.codedeploy.json
}