#Creating the application
resource "google_apphub_application" "apphub_application" {
  project = var.project_id
  location = var.location
  application_id = var.application_id
  display_name = var.display_name
  scope {
    type = var.scope_type
  }
  description = var.description
  attributes {
    environment {
      type = var.environment_type
        }
        criticality {  
      type = var.criticality_type
        }
        business_owners {
          display_name =  var.owner_name
          email        =  var.owner_email
        }
        developer_owners {
          display_name =  var.owner_name
          email        =  var.owner_email
        }
        operator_owners {
          display_name =  var.owner_name
          email        =  var.owner_email
        }
  }
}

#Attaching service project; assuming host project and service project are the same
resource "google_apphub_service_project_attachment" "attach_service_project" {
 project = var.project_id
 service_project_attachment_id = var.project_id
}

#Discover a service
data "google_apphub_discovered_service" "services" {
  for_each = { for service in var.service_uris : service.service_uri => service }

  location    = var.location
  service_uri = each.key
}

# Register a service
resource "google_apphub_service" "register_services" {
  for_each = { for service in var.service_uris : service.service_uri => service }

  location          = var.location
  application_id    = var.application_id
  service_id        = each.value.service_id
  discovered_service = data.google_apphub_discovered_service.services[each.value.service_uri].name
}

#Discover a workload
data "google_apphub_discovered_workload" "workloads" {
  for_each = { for workload in var.workload_uris : workload.workload_uri => workload }

  location    = var.location
  workload_uri = each.key
}

# Register a workload
resource "google_apphub_workload" "register_workloads" {
  for_each = { for workload in var.workload_uris : workload.workload_uri => workload }

  location           = var.location
  application_id    = var.application_id
  workload_id        = each.value.workload_id
  discovered_workload = data.google_apphub_discovered_workload.workloads[each.value.workload_uri].name
}