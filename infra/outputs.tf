output "three-tier-app-frontend-cloud_run_service_endpoint" {
  value = module.three-tier-app-frontend.service_url
  description = "Cloud Run service endpoint"
}
