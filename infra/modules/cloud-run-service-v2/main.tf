resource "google_cloud_run_v2_service" "main" {
  provider                   = google-beta
  name                       = var.service_name
  location                   = var.location
  project                    = var.project_id


  template {
    service_account = var.service_account_email

    scaling {
      max_instance_count = var.max_instance_count
      min_instance_count = var.min_instance_count
    }

    dynamic "vpc_access" {
      for_each = var.vpc_access_connector_ids
      content  {
        connector = vpc_access.value
        egress = var.vpc_access_egress
        }
    }

    containers {
      # Cloud SQL Proxy Sidecar Container
      image = "gcr.io/cloudsql-docker/gce-proxy:latest"
      command = [
        "/cloud_sql_proxy",
        "-instances=${var.instance_connection_name}=tcp:5432",
        "-enable_iam_login",
      ]
    }


    containers {
      image = var.image
      ports {
        container_port = var.port
      }
      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.value["name"]
          value = env.value["value"]
        }
      }
    }
  }   // template
}

resource "google_cloud_run_service_iam_member" "authorize" {
  count    = length(var.members)
  location = google_cloud_run_v2_service.main.location
  project  = google_cloud_run_v2_service.main.project
  service  = google_cloud_run_v2_service.main.name
  role     = "roles/run.invoker"
  member   = var.members[count.index]
}