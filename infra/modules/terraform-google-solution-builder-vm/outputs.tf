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

output "load_balancer_port_name" {
  description = "Port name for load balancer to connect to the VM instances"
  value       = local.load_balancer_port_name
}

output "managed_instance_group" {
  description = "Managed instance group"
  value = module.mig
}

output "module_dependency" {
  value = {}
  depends_on = [module.instance_template, module.mig]
  description = "Dependency variable that can be used by other modules to depend on this module"
}

output "cloud_run_service_account_name" {
  value = "${google_service_account.runsa.account_id}@${var.project_id}.iam"
}

output "env_variables" {
  value = {
    "BACKEND_SERVICE_ENDPOINT" = google_compute_address.static_ip.address
  }
}