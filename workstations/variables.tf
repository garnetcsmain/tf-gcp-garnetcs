variable "project_id" {
  description = "The project ID for the workstation."
  type        = string
}

variable "region" {
  description = "The region for the workstation cluster."
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the workstation cluster."
  type        = string
  default     = "xen-cluster"
}

variable "config_name" {
  description = "The name of the workstation configuration."
  type        = string
  default     = "jose-workstation-config"
}
