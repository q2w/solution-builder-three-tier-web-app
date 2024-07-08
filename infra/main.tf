module "three_tier_app_vpc" {
    source = "github.com/terraform-google-modules/terraform-google-network//modules/vpc?ref=v9.1.0"
    project_id = var.project_id
    network_name = var.three_tier_app_vpc_network_name
    auto_create_subnetworks = var.three_tier_app_vpc_auto_create_subnetworks
}

module "three_tier_app_vpc_access_connector" {
    source = "github.com/q2w/terraform-google-network//modules/vpc-serverless-connector-beta"
    project_id = var.project_id
    vpc_connectors = [ merge(var.three_tier_app_vpc_access_connector_vpc_connectors[0], { "network": module.three_tier_app_vpc.network_name}) ]
    depends_on = [ module.three_tier_app_vpc ] // how will this be populated
}

module "three_tier_app_global_address" {
    source = "github.com/terraform-google-modules/terraform-google-address?ref=v3.2.0"
    project_id = var.project_id
    region = var.region
    global = var.three_tier_app_global_address_global
    purpose = var.three_tier_app_global_address_purpose
    subnetwork = var.three_tier_app_global_address_subnetwork
    names = var.three_tier_app_global_address_names
    depends_on = [ module.three_tier_app_vpc ] // ?
}

module "three_tier_app_vpc_service_networking" {
    source = "./modules/service-networking"
    global_address_names = module.three_tier_app_global_address.names
    network_name = module.three_tier_app_vpc.network_self_link
}

module "three_tier_app_sa" {
    source = "github.com/q2w/terraform-google-service-accounts//modules/simple-sa"
    project_id = var.project_id
    name = var.three_tier_app_sa_name
    project_roles = var.three_tier_app_sa_project_roles
}

module "three_tier_app_cache" {
    source = "github.com/q2w/terraform-google-memorystore"
    project = var.project_id
    region = var.region
    name = var.three_tier_app_cache_name
    memory_size_gb = var.three_tier_app_cache_memory_size_gb
    redis_version = var.three_tier_app_cache_redis_version
    connect_mode = var.three_tier_app_cache_connect_mode
    tier = var.three_tier_app_cache_tier
    transit_encryption_mode = var.three_tier_app_cache_transit_encryption_mode
    authorized_network = module.three_tier_app_vpc.network_name
    depends_on = [ module.three_tier_app_vpc ] // ?
}

module "three_tier_app_database" {
    source = "github.com/q2w/terraform-google-sql-db//modules/postgresql"
    project_id = var.project_id
    region = var.region
    db_name = var.three_tier_app_database_db_name
    name = var.three_tier_app_database_name
    iam_users = [ module.three_tier_app_sa.id ]
    database_version = var.three_tier_app_database_database_version
    disk_size = var.three_tier_app_database_disk_size
    database_flags = var.three_tier_app_database_database_flags
    ip_configuration = { ipv4_enabled: var.three_tier_app_database_ip_configuration.ipv4_enabled, private_network: module.three_tier_app_vpc.network_id }
    deletion_protection = var.three_tier_app_database_deletion_protection
    user_deletion_policy = var.three_tier_app_database_user_deletion_policy
    database_deletion_policy = var.three_tier_app_database_database_deletion_policy
    enable_default_user = var.three_tier_app_database_enable_default_user
    depends_on = [ module.three_tier_app_vpc, module.three_tier_app_vpc_service_networking, module.three_tier_app_sa.email ] // ?
}

module "three_tier_app_backend" {
    source = "github.com/q2w/terraform-google-cloud-run//modules/v2"
    project_id = var.project_id
    location = var.region // why location and not region
    service_name = var.three_tier_app_backend_service_name
    service_account = module.three_tier_app_sa.email
    members = var.three_tier_app_backend_members
    containers = [
        {   container_image: var.three_tier_app_backend_containers[0].container_image,
            ports: var.three_tier_app_backend_containers[0].ports,
            env_vars: merge(module.three_tier_app_cache.env_vars,
                module.three_tier_app_database.env_vars,
                module.three_tier_app_sa.env_vars)
        }
    ]
    vpc_access = { connector: one(module.three_tier_app_vpc_access_connector.connector_ids), egress: var.three_tier_app_backend_vpc_access.egress }
    template_scaling = var.three_tier_app_backend_template_scaling
}

module "three_tier_app_frontend" {
    source = "github.com/q2w/terraform-google-cloud-run//modules/v2"
    project_id = var.project_id
    location = var.region
    service_name = var.three_tier_app_frontend_service_name
    members = var.three_tier_app_frontend_members
    containers = [
        {   container_image: var.three_tier_app_frontend_containers[0].container_image,
            ports: var.three_tier_app_frontend_containers[0].ports,
            env_vars: { "BACKEND_SERVICE_ENDPOINT": module.three_tier_app_backend.service_uri }
        }
    ]
}

module "three_tier_app_apphub" {
    source = "./modules/apphub"
    project_id = var.project_id
    location = var.region
    application_id = var.three_tier_app_apphub_application_id
    display_name = var.three_tier_app_apphub_display_name
    criticality_type = var.three_tier_app_apphub_criticality_type
    environment_type = var.three_tier_app_apphub_environment_type
    owner_email = var.three_tier_app_apphub_owner_email
    owner_name = var.three_tier_app_apphub_owner_name
    scope_type = var.three_tier_app_apphub_scope_type
    # This will be output from each service/workload.
    service_uris = [ { service_uri: "//compute.googleapis.com/projects/abhiwa-test-30112023/regions/us-central1/forwardingRules/a565a73f8b70642bd87d58e9adb0fdb5",
        service_id: "a565a73f8b70642bd87d58e9adb0fdb5" } ]
}
