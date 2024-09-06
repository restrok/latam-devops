resource "google_cloudbuild_trigger" "default" {
  location = var.location
  name     = var.name
  filename = "${path.module}/${var.filename}"

  dynamic "github" {
    for_each = var.github_configurations == null ? [] : [var.github_configurations]
    content {
      owner = github.value.owner
      name  = github.value.repo

      push {
        branch = github.value.push.branch
      }
    }
  }
}