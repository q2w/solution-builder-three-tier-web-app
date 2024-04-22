module "three-tier-app-vpc-network" {
    source = "github.com/ayushmjain/terraform-google-solution-builder-vpc-network?ref=v1.0.0"
    project_id = var.project_id
    region = var.region
    network_name = var.three-tier-app-vpc-network-network_name
}

module "three-tier-app-cache" {
    source = "github.com/ayushmjain/terraform-google-solution-builder-redis?ref=v1.0.0"
    project_id = var.project_id
    region = var.region
    redis_instance_name = var.three-tier-app-cache-redis_instance_name
    network_name = module.three-tier-app-vpc-network.network_name
    memory_size_gb = var.three-tier-app-cache-memory_size_gb
    redis_version = var.three-tier-app-cache-redis_version
}

module "three-tier-app-database" {
    source = "github.com/ayushmjain/terraform-google-solution-builder-cloud-sql?ref=v1.0.0"
    project_id = var.project_id
    region = var.region
    database_name = var.three-tier-app-database-database_name
    network_name = module.three-tier-app-vpc-network.network_name
    network_dependency = module.three-tier-app-vpc-network.module_dependency
    user_service_account_name = module.three-tier-app-backend.mig_service_account_name
    database_version = var.three-tier-app-database-database_version
    disk_size = var.three-tier-app-database-disk_size
}

module "three-tier-app-backend" {
    source = "github.com/q2w/terraform-google-solution-builder-vm?ref=v1.0.0"
    project_id = var.project_id
    region = var.region
    managed_instance_group_name = var.three-tier-app-backend-mig_service_name
    vm_image = var.three-tier-app-backend-vm_image
    vm_image_project = var.project_id
    env_variables = merge(var.backend_env_variable, module.three-tier-app-cache.env_variables, module.three-tier-app-database.env_variables)
    dependencies = [module.three-tier-app-database.module_dependency]
    network_name = module.three-tier-app-vpc-network.network_name
    public_access_firewall_rule_name = var.three-tier-app-backend-public-access-firewall-rule-name
    load_balancer_port = var.backend_load_balancer_port
    health_check_name = var.backend_health_check_name
    health_check_request_path = var.backend_health_check_request_path
    startup_script = var.backend_startup_script
}

module "three-tier-app-backend-lb" {
    source = "github.com/q2w/terraform-google-solution-builder-external-application-load-balancer?ref=v1.0.0"
    project_id = var.project_id
    load_balancer_name = var.backend_load_balancer_name
    load_balancer_port_name = module.three-tier-app-backend.load_balancer_port_name
    managed_instance_group_urls = [module.three-tier-app-backend.managed_instance_group_url]
    managed_instance_group_health_check_links = module.three-tier-app-backend.health_check_link != "" ? [ module.three-tier-app-backend.health_check_link] : []
}

module "three-tier-app-frontend" {
    source = "github.com/q2w/terraform-google-solution-builder-vm?ref=v1.0.0"
    project_id = var.project_id
    region = var.region
    managed_instance_group_name = var.three-tier-app-frontend-mig_service_name
    vm_image = var.three-tier-app-frontend-vm_image
    vm_image_project = var.project_id
    env_variables = merge(var.frontend_env_variable, { "BACKEND_SERVICE_ENDPOINT": module.three-tier-app-backend-lb.load_balancer_ip })
    public_access_firewall_rule_name = var.three-tier-app-frontend-public-access-firewall-rule-name
    load_balancer_port = var.frontend_load_balancer_port
    health_check_name = var.frontend_health_check_name
    startup_script = var.frontend_startup_script
}

module "three-tier-app-frontend-lb" {
    source = "github.com/q2w/terraform-google-solution-builder-external-application-load-balancer?ref=v1.0.0"
    project_id = var.project_id
    load_balancer_name = var.frontend_load_balancer_name
    load_balancer_port_name = module.three-tier-app-frontend.load_balancer_port_name
    managed_instance_group_urls = [module.three-tier-app-frontend.managed_instance_group_url]
    managed_instance_group_health_check_links = module.three-tier-app-frontend.health_check_link != "" ? [ module.three-tier-app-frontend.health_check_link] : []
}
