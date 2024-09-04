resource "google_api_gateway_api" "api" {
  api_id = var.api_name
}

resource "google_api_gateway_api_config" "api_config" {
  api       = google_api_gateway_api.api.api_id
  api_config_id = var.api_config_name

  openapi_documents {
    document {
      path = "openapi.yaml"
      contents = templatefile("${path.module}/openapi.yaml.tpl", {
        upload_data_url = var.functions.upload_data
        get_data_url    = var.functions.get_data
      })
    }
  }
}

resource "google_api_gateway_gateway" "gateway" {
  api         = google_api_gateway_api.api.api_id
  api_config  = google_api_gateway_api_config.api_config.api_config_id
  gateway_id  = var.gateway_name
  region      = var.region
}