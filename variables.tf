# GCP Project Settings
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Project Region"
}

variable "zone" {
  type        = string
  description = "GCP Project Zone"
}

variable "artifact_repo" {
  type        = string
  description = "GCP Artifact Repository name"
  default     = "discord-bots"
}

# Git Settings
variable "owner" {
  type        = string
  description = "Owner of the git repo"
}

variable "repo" {
  type        = string
  description = "Name of the git repo"
}

variable "branch" {
  type        = string
  default     = "master"
  description = "Git branch watched for build triggers"
}

# VM Settings
variable "vm_type" {
  type        = string
  description = "CE Instance Type"
  default     = "e2-micro"
}

# Bot Settings
variable "bot_name" {
  type        = string
  description = "Bot Name"
}

variable "bot_token" {
  type        = string
  description = "Bot API Token"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Bot Command Prefix"
}

# Firestore Settings
variable "db_enable" {
  type        = bool
  description = "Enable/Disable Firestore Instance"
  default     = false
}
