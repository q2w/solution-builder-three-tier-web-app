#Creating the application
resource "google_apphub_application" "apphub_application" {
  project = var.project_id
  location = var.app_location
  application_id = var.application_name
  display_name = "AppHub Application"
  scope {
    type = var.scope_type
  }
  description = "Application"
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
data "google_apphub_discovered_service" "service1" {
  location = var.app_location
  service_uri = var.uri_service
}

#Register the service with the application
resource "google_apphub_service" "register_service" {
  location = var.app_location
  application_id = var.application_name
  service_id = "registered-service1"
  discovered_service = data.google_apphub_discovered_service.service1.name
}

#Discover a workload 
data "google_apphub_discovered_workload" "workload1" {
  location = var.app_location
  workload_uri = var.uri_workload
}
#Register a workload with the Application
resource "google_apphub_workload" "register_workload" {
  location = var.app_location
  application_id = var.application_name
  workload_id = "registered-workload1"
  discovered_workload = data.google_apphub_discovered_workload.workload1.name
}