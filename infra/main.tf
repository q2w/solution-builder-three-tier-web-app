data "google_project" "project" {
    project_id = var.project_id
}

module "three-tier-app-sa" {
    source = "github.com/terraform-google-modules/terraform-google-service-accounts?ref=v4.2.3"
    project_id = var.project_id
    names = [var.backend-service_account_name]
    project_roles = [
        "${data.google_project.project.number}=>roles/cloudsql.instanceUser",
        "${data.google_project.project.number}=>roles/cloudsql.client",
    ]
}

module "three-tier-app-cache" {
    source = "github.com/terraform-google-modules/terraform-google-memorystore?ref=v8.0.0"
    project = var.project_id
    region = var.region
    name = var.three-tier-app-cache-redis_instance_name
    memory_size_gb = var.three-tier-app-cache-memory_size_gb
    redis_version = var.three-tier-app-cache-redis_version
    connect_mode = var.cache-connect_mode
    tier = var.cache-tier
    transit_encryption_mode = var.cache-transit_encryption_mode
}

module "three-tier-app-database" {
    source = "github.com/terraform-google-modules/terraform-google-sql-db//modules/postgresql?ref=v20.0.0"
    project_id = var.project_id
    region = var.region
    db_name = var.three-tier-app-database-database_name
    name = "${var.three-tier-app-database-database_name}-instance"
    iam_users = [{ id: var.backend-service_account_name, email: module.three-tier-app-sa.email }]
    database_version = var.three-tier-app-database-database_version
    disk_size = var.three-tier-app-database-disk_size
    database_flags = var.database-flags
}

module "three-tier-app-backend" {
    source = "github.com/GoogleCloudPlatform/terraform-google-cloud-run?ref=v0.10.0"
    project_id = var.project_id
    location = var.region
    service_name = var.three-tier-app-backend-cloud_run_service_name
    image = var.three-tier-app-backend-cloud_run_service_image
    env_vars = [
        { name: "REDIS_HOST", value : module.three-tier-app-cache.host },
        { name: "REDIS_PORT", value : module.three-tier-app-cache.port },
        { name: "CLOUD_SQL_DATABASE_HOST", value : module.three-tier-app-database.instance_first_ip_address } ,
        {
            name: "CLOUD_SQL_DATABASE_CONNECTION_NAME", value: module.three-tier-app-database.instance_connection_name
        },
        { name: "CLOUD_SQL_DATABASE_NAME", value: var.three-tier-app-database-database_name },
        { name: "SERVICE_ACCOUNT", value : module.three-tier-app-sa.email }
    ]
    template_annotations = merge({
        "run.googleapis.com/cloudsql-instances" = module.three-tier-app-database.instance_connection_name
    }, var.backend-template_annotations)
    service_account_email = module.three-tier-app-sa.email
    ports = var.cloud_run_port
    members = var.cloud_run_users
}

module "three-tier-app-frontend" {
    source = "github.com/GoogleCloudPlatform/terraform-google-cloud-run?ref=v0.10.0"
    project_id = var.project_id
    location = var.region
    service_name = var.three-tier-app-frontend-cloud_run_service_name
    image = var.three-tier-app-frontend-cloud_run_service_image
    env_vars = [{ name: "LOAD_BALANCER_IP_ADDRESS", value : module.three-tier-app-backend.service_url}]
    ports = var.cloud_run_port
    members = var.cloud_run_users
}
