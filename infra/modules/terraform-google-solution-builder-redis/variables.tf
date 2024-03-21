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
  description = "GCP project ID where the Redis instance is created"
}

variable "region" {
  type = string
  description = "GCP region where the Redis instance is created"
}

variable "network_name" {
  type = string
  default = null
  description = "VPC network name where the Redis instance is created"
}

variable "redis_instance_name" {
  type = string
  description = "Redis instance name"
}

variable "memory_size_gb" {
  type = number
  default = 1
  description = "Redis memory size in GiB"
}

variable "redis_version" {
  type = string
  description = "The version of Redis software"
  default = "REDIS_6_X"
  validation {
    condition     = var.redis_version == "REDIS_3_2" || var.redis_version == "REDIS_4_0" || var.redis_version == "REDIS_5_0" || var.redis_version == "REDIS_6_X" || var.redis_version == "REDIS_7_0"
    error_message = "Invalid redis version"
  }
}
