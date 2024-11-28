resource "google_workstations_workstation_config" "jose_workstation_config" {
  name         = "jose-workstation-config"
  project      = var.project_id
  region       = var.region
  workstation_cluster = google_workstations_workstation_cluster.xen_cluster.id

  idle_timeout        = "3600s" # Automatically shuts down after 1 hour of inactivity
  enable_audit_agent  = true

  container {
    image = "gcr.io/google.com/cloudsdktool/cloud-sdk:slim"
    command = ["/bin/bash"]
  }

  labels = {
    "env"      = "development"
    "project"  = var.project_id
  }
}

resource "google_workstations_workstation" "jose_workstation" {
  name                  = "jose-workstation"
  project               = var.project_id
  region                = var.region
  workstation_config_id = google_workstations_workstation_config.jose_workstation_config.id

  annotations = {
    "developer" = "Jose Hernandez"
  }
}

resource "google_workstations_workstation_cluster" "xen_cluster" {
  name    = "xen-workstation-cluster"
  project = var.project_id
  region  = var.region
  labels = {
    "project" = var.project_id
  }
}
