data "aws_region" "current" {}

locals {
  service_prefix = "${var.prefix}-${var.app_name}"
}

resource "aws_ecr_repository" "this" {
  name                 = "${local.service_prefix}-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}


resource "aws_cloudwatch_log_group" "this" {
  name = "${local.service_prefix}-logs"
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "xray" {
  name = "${local.service_prefix}-xray-logs"
  tags = var.tags
}


# module "deploy" {
#   source = "../../codedeploy"

#   name    = var.app_name
#   prefix = var.prefix
#   alb_arn = aws_alb.this.arn
#   alb_target_group_names = [
#     aws_alb_target_group.blue.name,
#     aws_alb_target_group.green.name
#   ]
#   aws_alb_default_listener_arn = aws_alb_listener.default_https.arn

#   ecs_cluster_name = var.ecs_cluster_name
#   ecs_service_name = aws_ecs_service.this.name
#   ecs_service_id   = aws_ecs_service.this.id

#   tags = var.tags
# }