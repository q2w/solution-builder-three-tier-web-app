module "database" {
  source                   = "github.com/ayushmjain/terraform-google-sql-db//modules/postgresql?ref=v1.0.5"
  project_id               = var.project_id
  name                     = "database-instance-test"
  database_version         = "POSTGRES_14"
  region                   = "us-central1"
  database_flags           = [{"name" = "cloudsql.iam_authentication", "value" = "on"}]
  db_name                  = "database"
  iam_users                = [module.backend.service_account_id]
  deletion_protection      = false
  enable_default_user      = false
  database_deletion_policy = "ABANDON"
  user_deletion_policy     = "ABANDON"
}
module "memorystore" {
  source                  = "github.com/ayushmjain/terraform-google-memorystore?ref=v1.0.0"
  region                  = "us-central1"
  project                 = "abhiwa-test-30112023"
  name                    = "redis-instance-test"
  tier                    = "BASIC"
  redis_version           = "REDIS_6_X"
  connect_mode            = "DIRECT_PEERING"
  transit_encryption_mode = "DISABLED"
}
module "backend" {
  source       = "github.com/ayushmjain/terraform-google-cloud-run//modules/v2?ref=v1.0.6"
  project_id   = var.project_id
  service_name = "backend-service-test"
  location     = "us-central1"
  template_scaling = {
    max_instance_count = 4
  }
  vpc_access = {
    network_interfaces = {
      network    = "default"
      subnetwork = "default"
    }
  }
  containers                    = [{"container_image" = "gcr.io/abhiwa-test-30112023/three-tier-app-be", "env_vars" = merge(module.database.env_vars, module.memorystore.env_vars, {"SERVICE_ACCOUNT" = "backend-service-test-us-cen-sa@abhiwa-test-30112023.iam.gserviceaccount.com"}), "ports" = {"container_port" = 80}}]
  members                       = ["allUsers"]
  service_account_project_roles = ["roles/cloudsql.instanceUser", "roles/cloudsql.client"]
}
module "frontend" {
  source                 = "github.com/ayushmjain/terraform-google-cloud-run//modules/v2?ref=v1.0.6"
  project_id             = var.project_id
  service_name           = "frontend-service-test"
  location               = "us-central1"
  containers             = [{"container_image" = "gcr.io/abhiwa-test-30112023/three-tier-app-fe", "env_vars" = {"backend_SERVICE_ENDPOINT" = module.backend.service_uri}, "ports" = {"container_port" = 80}}]
  members                = ["allUsers"]
  create_service_account = false
}
