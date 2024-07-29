project_id = "abhiwa-test-30112023"
region     = "us-central1"

three_tier_app_cache_name                    = "redis-instance"
three_tier_app_cache_redis_version           = "REDIS_6_X"
three_tier_app_cache_connect_mode            = "DIRECT_PEERING"
three_tier_app_cache_tier                    = "BASIC"
three_tier_app_cache_transit_encryption_mode = "DISABLED"

three_tier_app_database_db_name                  = "database"
three_tier_app_database_name                     = "database-instance"
three_tier_app_database_database_version         = "POSTGRES_14"
three_tier_app_database_database_flags           = [{ name : "cloudsql.iam_authentication", value : "on" }]
three_tier_app_database_deletion_protection      = false
three_tier_app_database_user_deletion_policy     = "ABANDON"
three_tier_app_database_database_deletion_policy = "ABANDON"
three_tier_app_database_enable_default_user      = false
three_tier_app_database_ip_configuration         = { ipv4_enabled : false }

three_tier_app_backend_service_name     = "backend-service"
three_tier_app_backend_members          = ["allUsers"]
three_tier_app_backend_template_scaling = { max_instance_count : 4 }
three_tier_app_backend_containers = [
  {
    container_image : "gcr.io/abhiwa-test-30112023/three-tier-app-be:default-network-db"
    ports : { container_port : 80 }
  }
]
three_tier_app_backend_vpc_access = { network_interfaces : { network : "default", subnetwork : "default" } }
three_tier_app_backend_service_account_project_roles = [
  "roles/cloudsql.instanceUser",
  "roles/cloudsql.client"
]
three_tier_app_backend_env_vars = { "SERVICE_ACCOUNT" : "backend-service-us-central1-sa@abhiwa-test-30112023.iam.gserviceaccount.com" }

three_tier_app_frontend_service_name = "frontend-service"
three_tier_app_frontend_members      = ["allUsers"]
three_tier_app_frontend_containers = [
  {
    container_image : "gcr.io/abhiwa-test-30112023/three-tier-app-fe:1.2.1"
    ports : { container_port : 80 }
  }
]
