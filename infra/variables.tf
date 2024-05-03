variable "project_id" {
  type = string
  description = "GCP Project ID"
}

variable "region" {
  type = string
  description = "GCP Region"
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

variable "three-tier-app-backend-cloud_run_service_name" {
  type = string
  description = "Cloud Run service name"
}

variable "three-tier-app-backend-cloud_run_service_image" {
  type = string
  description = "Cloud Run service container image"
}

variable "three-tier-app-frontend-cloud_run_service_name" {
  type = string
  description = "Cloud Run service name"
}

variable "three-tier-app-frontend-cloud_run_service_image" {
  type = string
  description = "Cloud Run service container image"
}

variable "backend-service_account_name" {
  type = string
  default = "backend-service-account"
  description = "Service account name for backend."
}

variable "cache-connect_mode" {
  type = string
  default = "DIRECT_PEERING"
}

variable "cache-tier" {
  type = string
  default = "BASIC"
}

variable "cache-transit_encryption_mode" {
  type = string
  default = "DISABLED"
}

variable "database-flags" {
  type = list(object({name: string, value: string}))
  default =   [ { name: "cloudsql.iam_authentication", value: "on" }]
}

variable "backend-template_annotations" {
  type = map(string)
  default = {
    "autoscaling.knative.dev/maxScale"        = "8"
    "run.googleapis.com/client-name"          = "terraform"
    "run.googleapis.com/network-interfaces"  = "[{ network: \"default\", subnetwork: \"default\" }]"
  }
}

variable "cloud_run_users" {
  type = list(string)
  default = ["allUsers"]
}

variable "cloud_run_port" {
  type = object({name: string, port: number})
  default = { name: "http1", port: 80}
}