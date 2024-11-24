module "ecs" {
  source = "./services/ecs"
  prefix = local.prefix
  tags   = local.common_tags
}

module "tasks_sqs_queue" {
  source = "./services/sqs"

  name                      = "${local.prefix}-tasks"
  allowed_items_max         = 50
  message_retention_seconds = 1600
  allowed_arns = [
    module.service_api.task_role_arn,
    module.service_task_runner.task_role_arn,
  ]

  max_task_receive_count     = 3
  visibility_timeout_seconds = 60

  tags = local.common_tags
}

module "service_api" {
  source = "./services/ecs/services/api"
  prefix = local.prefix

  vpc_id                      = module.network.vpc_id
  private_subnets             = module.network.private_subnets[*].id
  public_subnets              = module.network.public_subnets[*].id
  private_subnets_cidr_blocks = module.network.private_subnets[*].cidr_block

  ecs_cluster_id   = module.ecs.ecs_cluster_id
  ecs_cluster_name = module.ecs.ecs_cluster_name
  task_definition  = var.ecs_service_api_task_definition

  tags = local.common_tags
}

module "service_task_runner" {
  source = "./services/ecs/services/task-runner"
  prefix = local.prefix

  vpc_id                      = module.network.vpc_id
  private_subnets             = module.network.private_subnets[*].id
  private_subnets_cidr_blocks = module.network.private_subnets[*].cidr_block

  ecs_cluster_id   = module.ecs.ecs_cluster_id
  ecs_cluster_name = module.ecs.ecs_cluster_name
  task_definition  = var.ecs_service_api_task_definition

  tags = local.common_tags
}