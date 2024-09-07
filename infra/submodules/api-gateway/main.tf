terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = ">= 4.34.0"
    }
  }
}

resource "google_api_gateway_api" "api" {
  api_id = var.api_name
}

resource "google_api_gateway_api_config" "api_config" {
  api           = google_api_gateway_api.api.api_id
  api_config_id = var.api_config_name

  openapi_documents {
    document {
      path = "openapi.yaml"
      contents = base64encode(templatefile("${path.root}/openapi.yaml.tpl", {
        upload_data_url = var.functions.upload_data
        get_data_url    = var.functions.get_data
      }))
    }
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "google_api_gateway_gateway" "gateway" {
  api_config = google_api_gateway_api_config.api_config.id
  gateway_id = var.gateway_name
  # region     = var.region
}