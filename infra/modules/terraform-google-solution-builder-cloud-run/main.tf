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

data "google_project" "project" {
  project_id = var.project_id
}

# Roles assigned to cloud run service account.
locals {
  run_roles = [
    "roles/cloudsql.instanceUser",
    "roles/cloudsql.client",
  ]
}

resource "random_string" "service_account_id" {
  length  = 10
  upper   = false
  special = false
  numeric  = false
  lower   = true
}

resource "google_service_account" "runsa" {
  project      = var.project_id
  account_id   = random_string.service_account_id.result
  display_name = "Service Account for Cloud Run"
}

resource "google_project_iam_member" "allrun" {
  for_each = toset(local.run_roles)
  project  = data.google_project.project.number
  role     = each.key
  member   = "serviceAccount:${google_service_account.runsa.email}"
}

resource "google_cloud_run_service" "main" {
  name     = var.cloud_run_service_name
  provider = google-beta
  location = var.region
  project  = var.project_id
  template {
    spec {
      service_account_name = google_service_account.runsa.email
      containers {
        image = var.cloud_run_service_image
        ports {
          container_port = 80
        }
        env {
          name  = "REDIS_HOST"
          value = var.redis_host
        }
        env {
          name  = "REDIS_PORT"
          value = var.redis_port
        }
        env {
          name  = "CLOUD_RUN_SERVICE_ACCOUNT"
          value = google_service_account.runsa.email
        }
        env {
          name  = "CLOUD_SQL_DATABASE_HOST"
          value = var.cloud_sql_database_host
        }
        env {
          name  = "CLOUD_SQL_DATABASE_CONNECTION_NAME"
          value = var.cloud_sql_database_connection_name
        }
        env {
          name  = "CLOUD_SQL_DATABASE_NAME"
          value = var.cloud_sql_database_name
        }
        env {
          name  = "BACKEND_SERVICE_ENDPOINT"
          value = var.backend_service_endpoint
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "8"
        "run.googleapis.com/cloudsql-instances"   = var.cloud_sql_database_connection_name
        "run.googleapis.com/client-name"          = "terraform"
        "run.googleapis.com/vpc-access-egress"    = var.vpc_access_connector_id != null ? "all" : null
        "run.googleapis.com/vpc-access-connector" = var.vpc_access_connector_id
      }
    }
  }

  autogenerate_revision_name = true
  depends_on = [
    var.cloud_sql_dependency
  ]
}

resource "google_cloud_run_service_iam_member" "noauth_api" {
  location = google_cloud_run_service.main.location
  project  = google_cloud_run_service.main.project
  service  = google_cloud_run_service.main.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}