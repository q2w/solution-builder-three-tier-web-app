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

variable "three-tier-app-backend-backend_service_endpoint" {
  type = string
  default = null
}

variable "three-tier-app-frontend-cloud_run_service_name" {
  type = string
}

variable "three-tier-app-frontend-cloud_run_service_image" {
  type = string
}

variable "three-tier-app-frontend-redis_host" {
  type = string
  default = null
}

variable "three-tier-app-frontend-redis_port" {
  type = string
  default = null
}

variable "three-tier-app-frontend-cloud_sql_database_host" {
  type = string
  default = null
}

variable "three-tier-app-frontend-cloud_sql_database_connection_name" {
  type = string
  default = null
}

variable "three-tier-app-frontend-cloud_sql_database_name" {
  type = string
  default = null
}

variable "three-tier-app-frontend-vpc_access_connector_id" {
  type = string
  default = null
}
