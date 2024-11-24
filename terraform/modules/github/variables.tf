variable "GITHUB_TOKEN" {
  type = string
}

variable "repo_path" {
  type = string
}

variable "repo_variables" {
  type    = list(object({ key : string, value : string }))
  default = []
}