output "api_gateway_host" {
  value = google_api_gateway_gateway.gateway.default_hostname
}