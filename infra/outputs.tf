output "service_uri" {
  value = module.three_tier_app_frontend.service_uri
  description = "Cloud Run service endpoint"
}
