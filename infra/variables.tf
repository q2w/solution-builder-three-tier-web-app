variable "project_id" {
  type = string
  default = "abhiwa-test-30112023"
  description = "GCP Project ID"
}

variable "region" {
  type = string
  default = "us-central1"
  description = "GCP Region"
}

variable "three-tier-app-vpc-network-network_name" {
  type = string
  default = "vpc-network-1"
  description = "VPC network name"
}

variable "three-tier-app-cache-redis_instance_name" {
  type = string
  default = "redis-instance"
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
  default = "database"
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

variable "three-tier-app-backend-cloud_run_service_name" {
  type = string
  default = "backend-service"
  description = "Cloud Run service name"
}

variable "three-tier-app-backend-cloud_run_service_image" {
  type = string
  default = "image-3"
  description = "Cloud Run service container image"
}

variable "three-tier-app-frontend-cloud_run_service_name" {
  type = string
  default = "frontend-service"
  description = "Cloud Run service name"
}

variable "three-tier-app-frontend-cloud_run_service_image" {
  type = string
  default = "image-1"
  description = "Cloud Run service container image"
}

variable "three-tier-app-frontend-vpc_access_connector_id" {
  type = string
  default = null
  description = "VPC access connector ID used for accessing a VPC network"
}
