variable "prefix" {
  type = string
}

variable "name" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "ecs_service_id" {
  type = string
}

variable "aws_alb_default_listener_arn" {
  type = string
}

variable "alb_target_group_names" {
  type = list(string)
}

variable "tags" {
  type = map(any)
}