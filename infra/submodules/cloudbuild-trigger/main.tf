terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.34.0"
    }
  }
}

resource "google_cloudbuild_trigger" "default" {
  provider = google-beta
  project = var.project_id
  location = var.region
  name     = var.name
  filename = "infra/${path.module}/${var.cloudbuild-config.filename}"
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"

  repository_event_config {
    repository = "projects/${var.project_id}/locations/${var.region}/connections/github/repositories/latam-devops"
    push { 
      branch = var.cloudbuild-config.github_configurations.branch
    }
  }

  service_account = "projects/${var.project_id}/serviceAccounts/latam-test@latam-test-434700.iam.gserviceaccount.com"

}