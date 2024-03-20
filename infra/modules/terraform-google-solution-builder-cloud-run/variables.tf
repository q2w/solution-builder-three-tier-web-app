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
  description = "GCP project ID where the cloud run service is created"
}

variable "region" {
  type = string
  description = "GCP region where the cloud run service is created"
}

variable "cloud_run_service_name" {
  type = string
  description = "Cloud Run service name"
}

variable "cloud_run_service_image" {
  type = string
  description = "Cloud Run service container image"
}

variable "vpc_access_connector_id" {
  type = string
  default = null
  description = "VPC access connector ID used for accessing a VPC network"
}

variable "env_variables" {
  type = map(string)
  default = {}
  description = "Environment variables for cloud run service"
}

variable "annotations" {
  type = map(string)
  default = {}
  description = "Annotations for cloud run service"
}

variable "dependencies" {
  type = list(any)
  default = []
  description = "Dependencies of cloud run service"
}
