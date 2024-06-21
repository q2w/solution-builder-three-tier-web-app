output "three_tier_app_backend_service_uri" {
  value = module.three_tier_app_backend.service_uri
  description = "Cloud Run service endpoint"
}

output "three_tier_app_frontend_service_uri" {
  value = module.three_tier_app_frontend.service_uri
  description = "Cloud Run service endpoint"
}
