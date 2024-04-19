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

variable "three-tier-app-backend-mig_service_image" {
  type = string
  description = "VM image for backend"
}

variable "three-tier-app-frontend-mig_service_name" {
  type = string
  description = "Frontend service name"
}

variable "three-tier-app-frontend-mig_service_image" {
  type = string
  description = "VM image for frontend"
}

variable "three-tier-app-backend-public-access-firewall-rule-name" {
  type = string
  description = "Name of the firewall rule for allowing http request to backend"
}

variable "three-tier-app-backend-static-ip-name" {
  type = string
  description = "Name of the static ip created for backend"
}

variable "three-tier-app-frontend-public-access-firewall-rule-name" {
  type = string
  description = "Name of the firewall rule for allowing http request to frontend"
}

variable "three-tier-app-frontend-static-ip-name" {
  type = string
  description = "Name of the static ip created for frontend"
}

