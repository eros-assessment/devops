resource "github_repository_environment" "repo_environment" {
  repository  = data.github_repository.repo.name
  environment = terraform.workspace
}

resource "github_actions_environment_variable" "this" {
  for_each      = { for v in var.repo_variables : v.key => v }
  repository    = data.github_repository.repo.name
  environment   = github_repository_environment.repo_environment.environment
  variable_name = each.key
  value         = each.value
}