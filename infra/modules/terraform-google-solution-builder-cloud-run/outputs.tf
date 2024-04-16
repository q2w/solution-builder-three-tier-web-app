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

output "cloud_run_service_endpoint" {
  value = google_cloud_run_service.main.status[0].url
  description = "Cloud Run service endpoint"
}

output "cloud_run_service_region" {
  description = "Cloud Run service region"
  value = google_cloud_run_service.main.location
}

output "cloud_run_service_account_name" {
  value = "${google_service_account.runsa.account_id}@${var.project_id}.iam"
  description = "Cloud Run service account name"
}

output "env_variables" {
  value = {
    "BACKEND_SERVICE_ENDPOINT" = google_cloud_run_service.main.status[0].url
  }
  description = "Cloud Run service endpoint exposed as environment variable which can be used by other compute resources to communicate with this cloud run service"
}

output "module_dependency" {
  value = {}
  depends_on = [google_cloud_run_service.main, google_cloud_run_service_iam_member.noauth_api, google_project_iam_member.allrun, google_service_account.runsa]
  description = "Dependency variable that can be used by other modules to depend on this module"
}
