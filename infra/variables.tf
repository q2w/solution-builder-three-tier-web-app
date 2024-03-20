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

variable "three-tier-app-database-database_name" {
  type = string
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
