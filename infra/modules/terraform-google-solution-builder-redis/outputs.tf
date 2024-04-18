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

output "redis_host" {
  value = google_redis_instance.main.host
  description = "Redis host"
}

output "redis_port" {
  value = google_redis_instance.main.port
  description = "Redis port"
}

output "env_variables" {
  value = {
    "REDIS_HOST" = google_redis_instance.main.host
    "REDIS_PORT" = google_redis_instance.main.port
  }
  description = "Environment variables exposed by the Redis module that can be used by compute resources to connect to the redis instance"
}

output "module_dependency" {
  value = {}
  depends_on = [google_redis_instance.main]
  description = "Dependency variable that can be used by other modules to depend on this module"
}
