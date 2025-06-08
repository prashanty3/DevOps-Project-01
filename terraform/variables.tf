variable "gcp_project_id" {
  description = "Your GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region (e.g., us-central1)"
  type        = string
  default     = "us-central1"
}

variable "db_password" {
  description = "MySQL root password (use TF_VAR_db_password or secrets)"
  type        = string
  sensitive   = true
}