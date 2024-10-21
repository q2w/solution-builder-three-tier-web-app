# Root level variables, no prefix of module name
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

# Variables for module three_tier_app_cache
variable "three_tier_app_cache_name" {
  type        = string
  description = "Redis instance name"
}

variable "three_tier_app_cache_redis_version" {
  type        = string
  description = "The version of Redis software"
}

variable "three_tier_app_cache_memory_size_gb" {
  type        = number
  default     = 1
  description = "Redis memory size in GiB"
}

variable "three_tier_app_cache_connect_mode" {
  type    = string
  default = null
}

variable "three_tier_app_cache_tier" {
  type    = string
  default = "STANDARD_HA"
}

variable "three_tier_app_cache_transit_encryption_mode" {
  type    = string
  default = "SERVER_AUTHENTICATION"
}

# Variables for module three_tier_app_database
variable "three_tier_app_database_db_name" {
  type        = string
  description = "Database name"
}

variable "three_tier_app_database_name" {
  type        = string
  description = "Database instance name"
}

variable "three_tier_app_database_database_version" {
  type        = string
  description = "Database version"
}

variable "three_tier_app_database_database_flags" {
  type    = list(object({ name : string, value : string }))
  default = []
}

variable "three_tier_app_database_disk_size" {
  type        = number
  default     = 10
  description = "The size of data disk in GB"
}

variable "three_tier_app_database_ip_configuration" {
  type = object({ ipv4_enabled : bool })
}

variable "three_tier_app_database_deletion_protection" {
  type    = bool
  default = true
}

variable "three_tier_app_database_user_deletion_policy" {
  type    = string
  default = null
}

variable "three_tier_app_database_database_deletion_policy" {
  type    = string
  default = null
}

variable "three_tier_app_database_enable_default_user" {
  type    = bool
  default = true
}

variable "three-tier-app-backend-mig_service_name" {
  type        = string
  description = "Backend service name"
}

variable "three-tier-app-backend-vm_image_project" {
  type        = string
  default     = "debian-cloud"
  description = "VM image project for backend"
}

variable "three-tier-app-backend-vm_image" {
  type        = string
  default     = "debian-12-bookworm-v20241009"
  description = "VM image for backend"
}

# variable "three-tier-app-frontend-mig_service_name" {
#   type = string
#   description = "Frontend service name"
# }

variable "three-tier-app-frontend-vm_image_project" {
  type        = string
  default     = "debian-cloud"
  description = "VM image project for frontend"
}

variable "three-tier-app-frontend-vm_image" {
  type        = string
  default     = "debian-12-bookworm-v20241009"
  description = "VM image for frontend"
}

# variable "three-tier-app-backend-public-access-firewall-rule-name" {
#   type = string
#   description = "Name of the firewall rule for allowing http request to backend"
# }

# variable "three-tier-app-frontend-public-access-firewall-rule-name" {
#   type = string
#   description = "Name of the firewall rule for allowing http request to frontend"
# }

# variable "frontend_load_balancer_name" {
#   type = string
#   description = "Name of the load balancer for frontend"
# }

# variable "backend_load_balancer_name" {
#   type = string
#   description = "Name of the load balancer for backend"
# }

variable "backend_env_variable" {
  type        = map(string)
  default     = {}
  description = "User provided environment variables for backend"
}

variable "frontend_env_variable" {
  type        = map(string)
  default     = {}
  description = "User provided environment variables for frontend"
}

variable "backend_load_balancer_port" {
  type        = number
  default     = null
  description = "Port on which backend load balancer will connect to backend service"
}

variable "frontend_load_balancer_port" {
  type        = number
  default     = null
  description = "Port on which frontend load balancer will connect to frontend service"
}

# variable "backend_health_check_name" {
#   type = string
#   description = "Health check name for backend service"
# }

# variable "frontend_health_check_name" {
#   type = string
#   description = "Health check name for frontend service"
# }

# variable "backend_health_check_request_path" {
#   type = string
#   description = "Health check request path for backend service"
# }

variable "backend_startup_script" {
  type        = string
  description = "Startup script for backend which will run after backend service is created. This is quivalent to entrypoint script in docker"
}

# variable "frontend_startup_script" {
#   type = string
#   description = "Startup script for frontend which will run after frontend service is created"
# }
