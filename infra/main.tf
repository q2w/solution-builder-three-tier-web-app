data "google_project" "project" {
    project_id = var.project_id
}

module "three-tier-app-vpc" {
    source = "github.com/terraform-google-modules/terraform-google-network//modules/vpc?ref=v9.1.0"
    project_id = var.project_id
    network_name = var.three-tier-app-vpc-network_name
    auto_create_subnetworks = var.three-tier-app-vpc-auto_create_subnetworks
}

module "three-tier-app-vpc-access-connector" {
    source = "github.com/terraform-google-modules/terraform-google-network//modules/vpc-serverless-connector-beta?ref=v9.1.0"
    project_id = var.project_id
    vpc_connectors = var.three-tier-app-vpc-access-connector-vpc_connectors
    depends_on = [ module.three-tier-app-vpc ]
}

module "three-tier-app-vpc-global-address" {
    source = "github.com/terraform-google-modules/terraform-google-address?ref=v3.2.0"
    project_id = var.project_id
    region = var.region
    global = var.three-tier-app-vpc-global-address-global
    purpose = var.three-tier-app-vpc-global-address-purpose
    subnetwork = var.three-tier-app-vpc-network_name
    names = var.three-tier-app-vpc-global-address-names
    depends_on = [ module.three-tier-app-vpc ]
}

module "three-tier-app-vpc-service-networking" {
    source = "./modules/service-networking"
    global_address_names = module.three-tier-app-vpc-global-address.names
    network_name = module.three-tier-app-vpc.network_self_link
}

module "three-tier-app-sa" {
    source = "github.com/terraform-google-modules/terraform-google-service-accounts?ref=v4.2.3"
    project_id = var.project_id
    names = var.three-tier-app-sa-names
    project_roles = var.three-tier-app-sa-project_roles
}

module "three-tier-app-cache" {
    source = "github.com/terraform-google-modules/terraform-google-memorystore?ref=v8.0.0"
    project = var.project_id
    region = var.region
    name = var.three-tier-app-cache-name
    memory_size_gb = var.three-tier-app-cache-memory_size_gb
    redis_version = var.three-tier-app-cache-redis_version
    connect_mode = var.three-tier-app-cache-connect_mode
    tier = var.three-tier-app-cache-tier
    transit_encryption_mode = var.three-tier-app-cache-transit_encryption_mode
    authorized_network = module.three-tier-app-vpc.network_name
    depends_on = [ module.three-tier-app-vpc ]
}

module "three-tier-app-database" {
    source = "github.com/terraform-google-modules/terraform-google-sql-db//modules/postgresql?ref=v17.0.1"
    project_id = var.project_id
    region = var.region
    db_name = var.three-tier-app-database-db_name
    name = var.three-tier-app-database-name
    iam_users = [{ id: var.three-tier-app-sa-names[0], email: module.three-tier-app-sa.email }]
    database_version = var.three-tier-app-database-database_version
    disk_size = var.three-tier-app-database-disk_size
    database_flags = var.three-tier-app-database-database_flags
    ip_configuration = { ipv4_enabled: false, private_network: "projects/${var.project_id}/global/networks/${module.three-tier-app-vpc.network_name}"}
    deletion_protection = var.three-tier-app-database-deletion_protection
    user_deletion_policy = var.three-tier-app-database-user_deletion_policy
    database_deletion_policy = var.three-tier-app-database-database_deletion_policy
    enable_default_user = var.three-tier-app-database-enable_default_user
    depends_on = [ module.three-tier-app-vpc, module.three-tier-app-vpc-service-networking, module.three-tier-app-sa.email ]
}

module "three-tier-app-backend" {
    source = "./modules/cloud-run-service-v2"
    project_id = var.project_id
    location = var.region
    service_name = var.three-tier-app-backend-service_name
    image = var.three-tier-app-backend-image
    port = var.three-tier-app-backend-port
    env_vars = [
        { name: "REDIS_HOST", value : module.three-tier-app-cache.host },
        { name: "REDIS_PORT", value : module.three-tier-app-cache.port },
        { name: "CLOUD_SQL_DATABASE_HOST", value : module.three-tier-app-database.instance_first_ip_address } ,
        {
            name: "CLOUD_SQL_DATABASE_CONNECTION_NAME", value: module.three-tier-app-database.instance_connection_name
        },
        { name: "CLOUD_SQL_DATABASE_NAME", value: var.three-tier-app-database-db_name },
        { name: "SERVICE_ACCOUNT", value : module.three-tier-app-sa.email }
    ]
    service_account_email = module.three-tier-app-sa.email
    vpc_access_connector_ids = module.three-tier-app-vpc-access-connector.connector_ids
    vpc_access_egress = var.three-tier-app-backend-vpc_access_egress
    max_instance_count = var.three-tier-app-backend-max_instance_count
    members = var.three-tier-app-backend-members
}

module "three-tier-app-frontend" {
    source = "./modules/cloud-run-service-v2"
    project_id = var.project_id
    location = var.region
    service_name = var.three-tier-app-frontend-service_name
    image = var.three-tier-app-frontend-image
    port = var.three-tier-app-frontend-port
    env_vars = [{ name: "LOAD_BALANCER_IP_ADDRESS", value : module.three-tier-app-backend.service_url}]
    members = var.three-tier-app-frontend-members
}
