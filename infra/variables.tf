variable "project_id" {
  type = string
  description = "GCP Project ID"
}

variable "region" {
  type = string
  description = "GCP Region"
}

variable "three-tier-app-vpc-network-network_name" {
  type = string
  description = "VPC network name"
}

variable "three-tier-app-cache-redis_instance_name" {
  type = string
  description = "Redis instance name"
}

variable "three-tier-app-cache-redis_version" {
  type = string
  default = "REDIS_6_X"
  description = "The version of Redis software"
}

variable "three-tier-app-cache-memory_size_gb" {
  type = number
  default = 1
  description = "Redis memory size in GiB"
}

variable "three-tier-app-database-database_name" {
  type = string
  description = "Database name"
}

variable "three-tier-app-database-database_version" {
  type = string
  default = "POSTGRES_14"
  description = "Database version"
}

variable "three-tier-app-database-disk_size" {
  type = number
  default = 10
  description = "The size of data disk in GB"
}

variable "three-tier-app-backend-mig_service_name" {
  type = string
  description = "Backend service name"
}

variable "three-tier-app-backend-vm_image" {
  type = string
  description = "VM image for backend"
}

variable "three-tier-app-frontend-mig_service_name" {
  type = string
  description = "Frontend service name"
}

variable "three-tier-app-frontend-vm_image" {
  type = string
  description = "VM image for frontend"
}

variable "three-tier-app-backend-public-access-firewall-rule-name" {
  type = string
  description = "Name of the firewall rule for allowing http request to backend"
}

variable "three-tier-app-frontend-public-access-firewall-rule-name" {
  type = string
  description = "Name of the firewall rule for allowing http request to frontend"
}

variable "frontend_load_balancer_name" {
  type = string
  description = "Name of the load balancer for frontend"
}

variable "backend_load_balancer_name" {
  type = string
  description = "Name of the load balancer for backend"
}

variable "backend_env_variable" {
  type = map(string)
  default = {}
  description = "User provided environment variables for backend"
}

variable "frontend_env_variable" {
  type = map(string)
  default = {}
  description = "User provided environment variables for frontend"
}

variable "backend_load_balancer_port" {
  type = number
  default = null
  description = "Port on which backend load balancer will connect to backend service"
}

variable "frontend_load_balancer_port" {
  type = number
  default = null
  description = "Port on which frontend load balancer will connect to frontend service"
}

variable "backend_health_check_name" {
  type = string
  description = "Health check name for backend service"
}

variable "frontend_health_check_name" {
  type = string
  description = "Health check name for frontend service"
}

variable "backend_health_check_request_path" {
  type = string
  description = "Health check request path for backend service"
}

variable "backend_startup_script" {
  type = string
  description = "Startup script for backend which will run after backend service is created. This is quivalent to entrypoint script in docker"
}

variable "frontend_startup_script" {
  type = string
  description = "Startup script for frontend which will run after frontend service is created"
}
