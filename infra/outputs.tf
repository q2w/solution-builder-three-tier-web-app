output "three-tier-app-frontend-vm_managed_instance_group" {
  value = module.three-tier-app-frontend.env_variables
  description = "Cloud Run service endpoint"
}
