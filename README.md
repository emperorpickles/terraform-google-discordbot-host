# Discord Bot Host

### General 

* Description: Creates build pipeline for deploying a containerized discord bot
* Created By: Caleb Kitzmann
* Provider Dependencies:
  * Google
* Terraform Version: v1.1.7


### Usage

* Terraform (basic example):

```hcl
module "module_name" {
  source = "git@github.com:emperorpickles/terraform-google-discordbot-host.git"

  project_id = "project_id"
  region     = "region"
  zone       = "zone"

  owner = "git_username"
  repo  = "git_repo"

  bot_name  = "bot_name"
  bot_token = "bot_token"
  prefix    = "bot_prefix"
}

```

* Terraform (alternate example):

```hcl
module "module_name" {
  source = "git@github.com:emperorpickles/terraform-google-discordbot-host.git"

  project_id = "project_id"
  region     = "region"
  zone       = "zone"

  owner = "git_username"
  repo  = "git_repo"

  vm_type = "e2-medium"

  bot_name  = "bot_name"
  bot_token = "bot_token"
  prefix    = "bot_prefix"
}

```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                         | Options    |  Type  | Required? | Notes              |
| :------------ | :---------------------------------- | :--------- | :----: | :-------: | :----------------- |
| project_id    | GCP Project ID                      |            | string |    Yes    | N/A                |
| region        | GCP Project Region                  |            | string |    Yes    | N/A                |
| zone          | GCP Project Zone                    |            | string |    Yes    | N/A                |
| artifact_repo | Artifact Registry repo name         |            | string |    No     | N/A                |
| owner         | Github username                     |            | string |    Yes    | N/A                |
| repo          | Name of the source Git repo         |            | string |    Yes    | N/A                |
| branch        | Git branch to watch for changes     |            | string |    No     | Defaults to master |
| vm_type       | Compute Engine instance size        |            | string |    No     | N/A                |
| bot_name      | Name of the bot being deployed      |            | string |    Yes    | N/A                |
| bot_token     | Discord API token for the bot       |            | string |    Yes    | N/A                |
| prefix        | Command prefix used by the bot      |            | string |    Yes    | N/A                |

#### Outputs

| Variable Name         | Description                      | Notes |
| :-------------------- | :------------------------------- | :---- |
| vm_id                 | unique id for vm                 | N/A   |
| vm_internal_ip        | internal ip address of vm        | N/A   |
| vm_external_ip        | external ip address of vm        | N/A   |
| ar_id                 | artifact registry id             | N/A   |
| cloudbuild_sa_name    | Cloud Build service account name | N/A   |
| cloudbuild_trigger_id | Cloud Build trigger id           | N/A   |