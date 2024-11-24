variable "prefix" {
  type = string
}

variable "app_name" {
  type    = string
  default = "task-runner"
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "task_definition" {
  type = object({
    desired_count = number
    task = object({
      cpu    = number
      memory = number
    })
    app = object({
      cpu    = number
      memory = number
    }),
    xray_sidecar = object({
      cpu    = number
      memory = number
    })
  })
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
}


variable "tags" {
  type = map(any)
}

