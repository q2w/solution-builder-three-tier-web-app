module "three_tier_app_cache" {
  source                  = "github.com/terraform-google-modules/terraform-google-memorystore"
  project_id              = var.project_id
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
  iam_users                = [{ id : "compute-service-account", email : "960586730010-compute@developer.gserviceaccount.com" }]
  database_version         = var.three_tier_app_database_database_version
  disk_size                = var.three_tier_app_database_disk_size
  database_flags           = var.three_tier_app_database_database_flags
  deletion_protection      = var.three_tier_app_database_deletion_protection
  user_deletion_policy     = var.three_tier_app_database_user_deletion_policy
  database_deletion_policy = var.three_tier_app_database_database_deletion_policy
  enable_default_user      = var.three_tier_app_database_enable_default_user
}

module "ttwa_backend_it" {
  source               = "github.com/terraform-google-modules/terraform-google-vm//modules/instance_template"
  project_id           = var.project_id
  region               = var.region
  source_image         = var.three-tier-app-backend-vm_image
  source_image_project = var.three-tier-app-backend-vm_image_project
  metadata             = merge(module.three_tier_app_cache.env_vars, module.three_tier_app_database.env_vars, { "SERVICE_ACCOUNT" : "960586730010-compute@developer.gserviceaccount.com" })
  startup_script       = var.backend_startup_script
  service_account      = { email : "960586730010-compute@developer.gserviceaccount.com", scopes : ["cloud-platform"] }
  access_config        = [{ nat_ip : null, network_tier : "PREMIUM" }]
}

module "three-tier-app-backend" {
  source            = "github.com/terraform-google-modules/terraform-google-vm//modules/mig"
  project_id        = var.project_id
  region            = var.region
  mig_name          = var.three-tier-app-backend-mig_service_name
  instance_template = module.ttwa_backend_it.self_link
  named_ports = [{name: "http", port: 80}]
}

module "three-tier-app-backend-lb" {
  source     = "github.com/terraform-google-modules/terraform-google-lb-http"
  project = var.project_id
  name       = "http-lb-mig"
  # target_tags = [var.three-tier-app-backend-mig_service_name]
  backends = {
    default = {
      port        = 80
      protocol    = "HTTP"
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false
      health_check = {
        request_path = "/api/v1/todo"
        port         = 80
      }
      log_config = {
        enable      = true
        sample_rate = 1.0
      }
      iap_config = {
        enable = false
      }
      groups = [
        {
          group = module.three-tier-app-backend.instance_group
        }
      ]
    }
  }
}

# module "ttwa_frontend_it" {
#   source = "github.com/terraform-google-modules/terraform-google-vm//modules/instance_template"
# }

# resource "google_compute_firewall" "allow_http" {
#   name = "http-lb-mig"
#   network  =  "default"
#   project = var.project_id
#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
#   source_ranges = ["0.0.0.0/0"]  # Allow from all IP addresses
#   target_tags   = ["http-lb-mig"]
# }

# module "three-tier-app-frontend" {
#     source = "github.com/terraform-google-modules/terraform-google-vm//modules/mig"
#     project_id = var.project_id
#     region = var.region
#     managed_instance_group_name = var.three-tier-app-frontend-mig_service_name
#     vm_image = var.three-tier-app-frontend-vm_image
#     vm_image_project = var.three-tier-app-frontend-vm_image_project
#     env_variables = merge(module.three-tier-app-backend-lb.env_variables)
#     public_access_firewall_rule_name = var.three-tier-app-frontend-public-access-firewall-rule-name
#     load_balancer_port = var.frontend_load_balancer_port
#     health_check_name = var.frontend_health_check_name
#     startup_script = var.frontend_startup_script
# }

# module "three-tier-app-frontend-lb" {
#     source = "github.com/q2w/terraform-google-solution-builder-external-application-load-balancer?ref=v1.0.1"
#     project_id = var.project_id
#     load_balancer_name = var.frontend_load_balancer_name
#     load_balancer_port_name = module.three-tier-app-frontend.load_balancer_port_name
#     managed_instance_group_urls = [module.three-tier-app-frontend.managed_instance_group_url]
#     managed_instance_group_health_check_links = [ module.three-tier-app-frontend.health_check_link]
# }
