terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
}

provider "github" {
  token = var.GITHUB_TOKEN # or `GITHUB_TOKEN`
}

data "github_repository" "repo" {
  full_name = var.repo_path
}