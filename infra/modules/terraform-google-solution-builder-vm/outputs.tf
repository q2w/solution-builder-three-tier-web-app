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

output "managed_instance_group_url" {
  value = module.mig.instance_group
  description = "Managed instance group URL"
}

output "health_check_link" {
  value = var.health_check_name != "" ? module.mig.health_check_self_links[0] : ""
  description = "Health check link"
}

output "module_dependency" {
  value = {}
  depends_on = [module.instance_template, module.mig]
  description = "Dependency variable that can be used by other modules to depend on this module"
}

output "env_variables" {
  value = {
    "BACKEND_SERVICE_ENDPOINT" = google_compute_address.static_ip.address
  }
}

output "mig_service_account_name" {
  value = "${google_service_account.runsa.account_id}@${var.project_id}.iam"
}