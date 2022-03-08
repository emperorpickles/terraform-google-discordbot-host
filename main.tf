terraform {
  cloud {
    organization = var.organization

    workspaces {
      name = var.workspace
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}



# Create userdata cloudinit data source
data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.yaml")

  vars = {
    region        = var.region
    project_id    = var.project_id
    image         = var.bot_name
    artifact_repo = var.artifact_repo
  }
}

# Create CE Instance with COS image
resource "google_compute_instance" "container_vm" {
  name         = var.bot_name
  machine_type = var.vm_type

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/family/cos-stable"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    user-data = "${data.template_file.userdata.rendered}"
  }

  tags = ["http-server", "https-server"]

  service_account {
    scopes = ["cloud-platform"]
  }
}



# Create Artifact Registry Repository
resource "google_artifact_registry_repository" "ar_repo" {
  provider = google-beta
  project  = var.project_id

  location      = var.region
  repository_id = var.artifact_repo
  description   = "docker repository for discord bot images"
  format        = "DOCKER"
}



# Create service account for Cloud Build that has access to Compute Engine
resource "google_service_account" "cloudbuild_sa" {
  account_id   = "cloudbuild-sa"
  display_name = "Service account for Cloud Build"
}

resource "google_project_iam_member" "cloudbuild_policy" {
  project = var.project_id
  count   = length(var.roles_list)
  role    = var.roles_list[count.index]
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Setup Cloud Build trigger for code changes
resource "google_cloudbuild_trigger" "build_trigger" {
  github {
    owner = var.owner
    name  = var.repo
    push {
      branch = var.branch
    }
  }

  service_account = google_service_account.cloudbuild_sa.id

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}/${var.bot_name}",
        "--build-arg", "BOT_TOKEN=${var.bot_token}",
        "--build-arg", "PREFIX=${var.prefix}",
        "--build-arg", "GCP_PROJECT_ID=$PROJECT_ID",
        "."
      ]
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}/${var.bot_name}"]
    }
    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
      entrypoint = "gcloud"
      args       = ["compute", "instances", "stop", var.bot_name, "--zone", var.zone]
    }
    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk:alpine"
      entrypoint = "gcloud"
      args       = ["compute", "instances", "start", var.bot_name, "--zone", var.zone]
    }

    options {
      logging = "STACKDRIVER_ONLY"
    }
  }
}


# Optional Firestore Database
resource "google_app_engine_application" "firestore_instance" {
  count = var.db_enable == true ? 1 : 0

  project     = var.project_id
  location_id = var.region

  database_type = "CLOUD_FIRESTORE"
}
