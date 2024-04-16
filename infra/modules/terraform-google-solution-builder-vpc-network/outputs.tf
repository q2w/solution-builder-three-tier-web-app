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

output "network_name" {
  value = google_compute_network.main.name
  description = "VPC network name"
}

output "vpc_access_connector_id" {
  value = google_vpc_access_connector.main.id
  description = "VPC access connector ID"
}

output "module_dependency" {
  value = {}
  depends_on = [google_compute_network.main, google_compute_global_address.main, google_vpc_access_connector.main, google_service_networking_connection.main]
  description = "Dependency variable that can be used by other modules to depend on this module"
}