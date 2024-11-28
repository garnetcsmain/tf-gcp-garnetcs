variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the workstation cluster"
  type        = string
  default     = "developer-cluster"
}

variable "config_name" {
  description = "The name of the workstation configuration"
  type        = string
  default     = "developer-config"
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1" 
}

variable "instance_name" {
  description = "The name of the compute instance"
  type        = string
  default     = "xen-web-instance"
}
