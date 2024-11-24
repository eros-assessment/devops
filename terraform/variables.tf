variable "ecs_service_api_task_definition" {
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

variable "ecs_service_task_runner_task_definition" {
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

variable "prefix" {
  type = string
}