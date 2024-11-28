output "workstation_url" {
  value = "https://workstations.google.com/${google_workstations_workstation.jose_workstation.project}/${google_workstations_workstation.jose_workstation.region}/${google_workstations_workstation.jose_workstation.name}"
  description = "URL to access Jose's workstation."
}
