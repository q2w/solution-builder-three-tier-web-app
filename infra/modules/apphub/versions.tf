terraform{
  required_version = ">= 0.13.0"
  
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 3.53, < 6"
    }
  }

}

provider "google"{
  project = var.project_id
}
