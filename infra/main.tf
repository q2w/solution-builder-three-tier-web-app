module "three-tier-app-vpc-network" {
    source = "./modules/terraform-google-solution-builder-vpc-network"
    project_id = var.project_id
    region = var.region
    network_name = var.three-tier-app-vpc-network-network_name
}

module "three-tier-app-cache" {
    source = "./modules/terraform-google-solution-builder-redis"
    project_id = var.project_id
    region = var.region
    redis_instance_name = var.three-tier-app-cache-redis_instance_name
    network_name = module.three-tier-app-vpc-network.network_name
    memory_size_gb = var.three-tier-app-cache-memory_size_gb
    redis_version = var.three-tier-app-cache-redis_version
}

module "three-tier-app-database" {
    source = "./modules/terraform-google-solution-builder-cloud-sql"
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
    source = "./modules/terraform-google-solution-builder-vm"
    project_id = var.project_id
    region = var.region
    managed_instance_group_name = var.three-tier-app-backend-mig_service_name
    vm_image = var.three-tier-app-backend-mig_service_image
    vm_image_project = var.project_id
    env_variables = merge({ "PORT": "8080"}, module.three-tier-app-cache.env_variables, module.three-tier-app-database.env_variables)
    dependencies = [module.three-tier-app-database.module_dependency]
    network_name = module.three-tier-app-vpc-network.network_name
    public_access_firewall_rule_name = var.three-tier-app-backend-public-access-firewall-rule-name
    static_ip_name = var.three-tier-app-backend-static-ip-name
    startup_script = "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080\n\n/app/todo-api"
}

module "three-tier-app-frontend" {
    source = "./modules/terraform-google-solution-builder-vm"
    project_id = var.project_id
    region = var.region
    managed_instance_group_name = var.three-tier-app-frontend-mig_service_name
    vm_image = var.three-tier-app-frontend-mig_service_image
    vm_image_project = var.project_id
    env_variables = merge(module.three-tier-app-backend.env_variables)
    public_access_firewall_rule_name = var.three-tier-app-frontend-public-access-firewall-rule-name
    static_ip_name = var.three-tier-app-frontend-static-ip-name
    startup_script = <<-EOF
  echo "RUNNING MASSAGE SCRIPT"
  API=$BACKEND_SERVICE_ENDPOINT
  stripped=$(printf '%s\n' "$API" | sed 's/https:\/\///')
  echo $stripped
  sed -i "s/127.0.0.1:9000/$stripped/" /var/www/html/js/main.js
  sudo systemctl start nginx
  EOF
}
