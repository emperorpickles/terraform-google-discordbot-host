terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

provider "google" {
  project = "project_id"
  region  = "region"
  zone    = "zone"
}

module "bot_deploy" {
  source = "git@github.com:emperorpickles/terraform-google-discordbot-host.git"

  project_id = "project_id"
  region     = "region"
  zone       = "zone"

  owner = "git_username"
  repo  = "git_repo"

  vm_type = "e2-micro"

  bot_name  = "bot_name"
  bot_token = "bot_token"
  prefix    = "bot_prefix"
}
