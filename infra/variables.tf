variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "three-tier-app-vpc-network-network_name" {
  type = string
}

variable "three-tier-app-cache-redis_instance_name" {
  type = string
}

variable "three-tier-app-cache-redis_version" {
  type = string
  default = "REDIS_6_X"
}

variable "three-tier-app-cache-memory_size_gb" {
  type = number
  default = 1
}

variable "three-tier-app-database-database_name" {
  type = string
}

variable "three-tier-app-database-database_version" {
  type = string
  default = "POSTGRES_14"
}

variable "three-tier-app-database-disk_size" {
  type = number
  default = 10
}

variable "three-tier-app-backend-cloud_run_service_name" {
  type = string
}

variable "three-tier-app-backend-cloud_run_service_image" {
  type = string
}

variable "three-tier-app-frontend-cloud_run_service_name" {
  type = string
}

variable "three-tier-app-frontend-cloud_run_service_image" {
  type = string
}

variable "three-tier-app-frontend-vpc_access_connector_id" {
  type = string
  default = null
}
