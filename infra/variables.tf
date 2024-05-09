variable "project_id" {
  type = string
  description = "GCP Project ID"
}

variable "region" {
  type = string
  description = "GCP Region"
}

variable "three-tier-app-vpc-network_name" {
  type = string
  description = "VPC network name"
}

variable "three-tier-app-cache-name" {
  type = string
  description = "Redis instance name"
}

variable "three-tier-app-cache-redis_version" {
  type = string
  description = "The version of Redis software"
}

variable "three-tier-app-cache-memory_size_gb" {
  type = number
  default = 1
  description = "Redis memory size in GiB"
}

variable "three-tier-app-database-db_name" {
  type = string
  description = "Database name"
}

variable "three-tier-app-database-name" {
  type = string
  description = "Database instance name"
}

variable "three-tier-app-database-database_version" {
  type = string
  description = "Database version"
}

variable "three-tier-app-database-disk_size" {
  type = number
  default = 10
  description = "The size of data disk in GB"
}

variable "three-tier-app-backend-service_name" {
  type = string
  description = "Backend cloud Run service name"
}

variable "three-tier-app-backend-image" {
  type = string
  description = "Cloud Run service container image"
}

variable "three-tier-app-frontend-service_name" {
  type = string
  description = "Cloud Run service name"
}

variable "three-tier-app-frontend-image" {
  type = string
  description = "Cloud Run service container image"
}

variable "three-tier-app-vpc-access-connector-name" {
  type = string
  default = null
  description = "VPC access connector ID used for accessing a VPC network"
}

variable "three-tier-app-sa-names" {
  type = list(string)
  description = "Service account names to be created."
}

variable "three-tier-app-cache-connect_mode" {
  type = string
  default = null
}

variable "three-tier-app-cache-tier" {
  type = string
  default = "STANDARD_HA"
}

variable "three-tier-app-cache-transit_encryption_mode" {
  type = string
  default = "SERVER_AUTHENTICATION"
}

variable "three-tier-app-database-database_flags" {
  type = list(object({name: string, value: string}))
  default =  []
}

variable "three-tier-app-backend-members" {
  type = list(string)
  default = []
}

variable "three-tier-app-frontend-members" {
  type = list(string)
  default = []
}

variable "three-tier-app-vpc-auto_create_subnetworks" {
  type = bool
  default = false
}

variable "three-tier-app-vpc-global-address-global" {
  type = bool
  default = false
}

variable "three-tier-app-vpc-global-address-purpose" {
  type = string
  default = "GCE_ENDPOINT"
}

variable "three-tier-app-vpc-global-address-names" {
  type = list(string)
  default = []
}

variable "three-tier-app-database-deletion_protection" {
  type = bool
  default = true
}

variable "three-tier-app-database-user_deletion_policy" {
  type = string
  default = null
}

variable "three-tier-app-database-database_deletion_policy" {
  type = string
  default = null
}

variable "three-tier-app-database-enable_default_user" {
  type = bool
  default = true
}

variable "three-tier-app-vpc-access-connector-vpc_connectors" {
  type = list(map(string))
  default = []
}

variable "three-tier-app-sa-project_roles" {
  type = list(string)
  default = []
}

variable "three-tier-app-backend-max_instance_count" {
  type = number
}

variable "three-tier-app-backend-vpc_access_egress" {
  type = string
}

variable "three-tier-app-backend-port" {
  type = number
  default = 80
}

variable "three-tier-app-frontend-port" {
  type = number
  default = 80
}