locals {
  name = "${var.prefix}-${var.name}"
}

resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = local.name
}
resource "aws_CODEDEPLOY_DEPLOYMENT_GROUP_API" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "${local.name}-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy.arn

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.aws_alb_default_listener_arn]
      }

      target_group {
        name = var.alb_target_group_names[0]
      }

      target_group {
        name = var.alb_target_group_names[1]
      }
    }
  }



  tags = var.tags
}