data "aws_iam_policy_document" "task_exec_role" {
  statement {
    sid     = "TaskExecutionAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_exec_policy" {
  statement {
    sid       = "AllowECROperations"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowECRepoOperations"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [aws_ecr_repository.this.arn]
  }

  statement {
    sid    = "AllowCloudwatchOperations"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*",
      "${aws_cloudwatch_log_group.xray.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "task_role" {
  statement {
    sid     = "TaskAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    sid    = "AllowXrayOperations"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "task_exec_role" {
  name               = "${local.service_prefix}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_role.json
  tags               = var.tags
}

resource "aws_iam_policy" "task_exec_role_policy" {
  name   = "${local.service_prefix}-task-exec-role-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.task_exec_policy.json
}

resource "aws_iam_role_policy_attachment" "task_exec_role" {
  role       = aws_iam_role.task_exec_role.name
  policy_arn = aws_iam_policy.task_exec_role_policy.arn
}

resource "aws_iam_role" "task_role" {
  name               = "${local.service_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_role.json

  tags = var.tags
}

resource "aws_iam_policy" "task_policy" {
  name        = "${local.service_prefix}-task-policy"
  description = "Task's resource access policy"
  policy      = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role_policy_attachment" "task_role" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}