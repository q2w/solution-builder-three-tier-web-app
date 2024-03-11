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
}

module "three-tier-app-database" {
    source = "./modules/terraform-google-solution-builder-cloud-sql"
    project_id = var.project_id
    region = var.region
    database_name = var.three-tier-app-database-database_name
    network_name = module.three-tier-app-vpc-network.network_name
    network_dependency = module.three-tier-app-vpc-network.module_dependency
    user_service_account_name = module.three-tier-app-backend.cloud_run_service_account_name
}

module "three-tier-app-backend" {
    source = "./modules/terraform-google-solution-builder-cloud-run"
    project_id = var.project_id
    region = var.region
    cloud_run_service_name = var.three-tier-app-backend-cloud_run_service_name
    cloud_run_service_image = var.three-tier-app-backend-cloud_run_service_image
    backend_service_endpoint = var.three-tier-app-backend-backend_service_endpoint
    redis_host = module.three-tier-app-cache.redis_host
    redis_port = module.three-tier-app-cache.redis_port
    cloud_sql_database_host = module.three-tier-app-database.database_host
    cloud_sql_database_connection_name = module.three-tier-app-database.database_connection_name
    cloud_sql_database_name = module.three-tier-app-database.database_name
    cloud_sql_dependency = module.three-tier-app-database.module_dependency
    vpc_access_connector_id = module.three-tier-app-vpc-network.vpc_access_connector_id   
}

module "three-tier-app-frontend" {
    source = "./modules/terraform-google-solution-builder-cloud-run"
    project_id = var.project_id
    region = var.region
    cloud_run_service_name = var.three-tier-app-frontend-cloud_run_service_name
    cloud_run_service_image = var.three-tier-app-frontend-cloud_run_service_image
    backend_service_endpoint = module.three-tier-app-backend.cloud_run_service_endpoint
    redis_host = var.three-tier-app-frontend-redis_host
    redis_port = var.three-tier-app-frontend-redis_port
    cloud_sql_database_host = var.three-tier-app-frontend-cloud_sql_database_host
    cloud_sql_database_connection_name = var.three-tier-app-frontend-cloud_sql_database_connection_name
    cloud_sql_database_name = var.three-tier-app-frontend-cloud_sql_database_name
    vpc_access_connector_id = var.three-tier-app-frontend-vpc_access_connector_id
}
