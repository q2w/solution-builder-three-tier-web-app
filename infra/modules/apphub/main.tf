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