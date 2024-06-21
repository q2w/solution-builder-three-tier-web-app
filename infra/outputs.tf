output "three-tier-app-frontend-cloud_run_service_endpoint" {
  value = module.three_tier_app_frontend.service_uri
  description = "Cloud Run service endpoint"
}
