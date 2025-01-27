output "backend_service_uri" {
  description = "The main URI in which this Service is serving traffic."
  value       = module.backend.service_uri
}
output "frontend_service_uri" {
  description = "The main URI in which this Service is serving traffic."
  value       = module.frontend.service_uri
}
