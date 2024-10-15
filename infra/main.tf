module "three_tier_app_cache" {
  source                  = "github.com/terraform-google-modules/terraform-google-memorystore"
  project                 = var.project_id
  region                  = var.region
  name                    = var.three_tier_app_cache_name
  memory_size_gb          = var.three_tier_app_cache_memory_size_gb
  redis_version           = var.three_tier_app_cache_redis_version
  connect_mode            = var.three_tier_app_cache_connect_mode
  tier                    = var.three_tier_app_cache_tier
  transit_encryption_mode = var.three_tier_app_cache_transit_encryption_mode
}

module "three_tier_app_database" {
  source                   = "github.com/terraform-google-modules/terraform-google-sql-db//modules/postgresql"
  project_id               = var.project_id
  region                   = var.region
  db_name                  = var.three_tier_app_database_db_name
  name                     = var.three_tier_app_database_name
  iam_users                = [module.three_tier_app_backend.service_account_id]
  database_version         = var.three_tier_app_database_database_version
  disk_size                = var.three_tier_app_database_disk_size
  database_flags           = var.three_tier_app_database_database_flags
  deletion_protection      = var.three_tier_app_database_deletion_protection
  user_deletion_policy     = var.three_tier_app_database_user_deletion_policy
  database_deletion_policy = var.three_tier_app_database_database_deletion_policy
  enable_default_user      = var.three_tier_app_database_enable_default_user
}

module "three_tier_app_backend" {
  source       = "github.com/GoogleCloudPlatform/terraform-google-cloud-run//modules/v2"
  project_id   = var.project_id
  location     = var.region // why location and not region
  service_name = var.three_tier_app_backend_service_name
  members      = var.three_tier_app_backend_members
  containers = [
    { container_image : var.three_tier_app_backend_containers[0].container_image,
      ports : var.three_tier_app_backend_containers[0].ports,
      env_vars : merge({
        "cloud_sql_a_CLOUD_SQL_DATABASE_HOST" : "VALUE",
        "cloud_sql_a_CLOUD_SQL_DATABASE_CONNECTION_NAME" : "VALUE",
        "cloud_sql_a_CLOUD_SQL_DATABASE_NAME" : "VALUE"
      }, 
      {
        "cloud_sql_b_CLOUD_SQL_DATABASE_HOST" : "VALUE",
        "cloud_sql_b_CLOUD_SQL_DATABASE_CONNECTION_NAME" : "VALUE",
        "cloud_sql_b_CLOUD_SQL_DATABASE_NAME" : "VALUE"
      },
      {
        "redis_a_REDIS_HOST" : google_redis_instance.default.host,
        "redis_a_REDIS_PORT" : tostring(google_redis_instance.default.port)
      },
      {
        "redis_b_REDIS_HOST" : google_redis_instance.default.host,
        "redis_b_REDIS_PORT" : tostring(google_redis_instance.default.port)
      },
      var.three_tier_app_backend_containers[0].env_vars)
    }
  ]
  vpc_access                    = var.three_tier_app_backend_vpc_access
  template_scaling              = var.three_tier_app_backend_template_scaling
  service_account_project_roles = var.three_tier_app_backend_service_account_project_roles
}

module "three_tier_app_frontend" {
  source                 = "github.com/GoogleCloudPlatform/terraform-google-cloud-run//modules/v2"
  project_id             = var.project_id
  location               = var.region
  service_name           = var.three_tier_app_frontend_service_name
  members                = var.three_tier_app_frontend_members
  create_service_account = false
  containers = [
    { container_image : var.three_tier_app_frontend_containers[0].container_image,
      ports : var.three_tier_app_frontend_containers[0].ports,
      env_vars : merge(
        { "cloud_run_a_SERVICE_ENDPOINT" : module.three_tier_app_backend.service_uri },
        { "cloud_run_b_SERVICE_ENDPOINT" : module.three_tier_app_backend.service_uri },
      )
    }
  ]
}
