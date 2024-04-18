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

output "database_connection_name" {
  value = google_sql_database_instance.main.connection_name
  description = "Cloud SQL database connection name"
}

output "database_host" {
  value = google_sql_database_instance.main.ip_address[0].ip_address
  description = "Cloud SQL database host"
}

output "database_name" {
  value = google_sql_database.database.name
  description = "Cloud SQL database name"
}

output "env_variables" {
  value = {
    "CLOUD_SQL_DATABASE_HOST" = google_sql_database_instance.main.ip_address[0].ip_address
    "CLOUD_SQL_DATABASE_CONNECTION_NAME" = google_sql_database_instance.main.connection_name
    "CLOUD_SQL_DATABASE_NAME" = google_sql_database.database.name
  }
  description = "Environment variables exposed by the Cloud SQL module that can be used by compute resources to connect to the Cloud SQL database"
}

output "module_dependency" {
  value = {}
  depends_on = [google_sql_database.database, google_sql_database_instance.main, google_sql_user.main]
  description = "Dependency variable that can be used by other modules to depend on this module"
}
