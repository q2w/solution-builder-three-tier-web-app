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

resource "google_sql_database_instance" "main" {
  name             = "${var.database_name}-instance"
  database_version = var.database_version
  region           = var.region
  project          = var.project_id
  settings {
    tier                  = "db-g1-small"
    disk_autoresize       = true
    disk_autoresize_limit = 0
    disk_size             = var.disk_size
    disk_type             = "PD_SSD"
    ip_configuration {
      ipv4_enabled    = var.network_name != null ? false : true
      private_network = var.network_name != null ? "projects/${var.project_id}/global/networks/${var.network_name}" : null
    }
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
  deletion_protection = false
  depends_on = [ var.network_dependency ]
}

resource "google_sql_user" "main" {
  project         = var.project_id
  name            = var.user_service_account_name
  type            = "CLOUD_IAM_SERVICE_ACCOUNT"
  instance        = google_sql_database_instance.main.name
  deletion_policy = "ABANDON"
}

resource "google_sql_database" "database" {
  project         = var.project_id
  name            = var.database_name
  instance        = google_sql_database_instance.main.name
  deletion_policy = "ABANDON"
}
