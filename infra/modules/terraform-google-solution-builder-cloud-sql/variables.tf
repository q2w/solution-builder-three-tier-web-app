/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type = string
  description = "GCP project ID where the Cloud SQL database is created"
}

variable "region" {
  type = string
  description = "GCP region where the Cloud SQL database is created"
}

variable "network_name" {
  type = string
  default = null
  description = "VPC network name where the Cloud SQL database is created"
}

variable "user_service_account_name" {
  type = string
  description = "Service account name that accesses the database"
}

variable "database_name" {
  type = string
  description = "Database name"
}

variable "network_dependency" {
  type = any
  default = null
  description = "Dependency on VPC Network"
}

variable "database_version" {
  type = string
  default = "POSTGRES_14"
  description = "Database version"
  validation {
    condition     = var.database_version == "MYSQL_5_6" || var.database_version == "MYSQL_5_7" || var.database_version == "MYSQL_8_0" || var.database_version == "POSTGRES_9_6" || var.database_version == "POSTGRES_10" || var.database_version == "POSTGRES_11" || var.database_version == "POSTGRES_12" || var.database_version == "POSTGRES_13" || var.database_version == "POSTGRES_14" || var.database_version == "POSTGRES_15" || var.database_version == "SQLSERVER_2017_STANDARD" || var.database_version == "SQLSERVER_2017_ENTERPRISE" || var.database_version == "SQLSERVER_2017_EXPRESS" || var.database_version == "SQLSERVER_2017_WEB" || var.database_version == "SQLSERVER_2019_STANDARD" || var.database_version == "SQLSERVER_2019_ENTERPRISE" || var.database_version == "SQLSERVER_2019_EXPRESS" || var.database_version == "SQLSERVER_2019_WEB"
    error_message = "Invalid database version"
  }
}

variable "disk_size" {
  type = number
  default = 10
  description = "The size of data disk in GB"
}
