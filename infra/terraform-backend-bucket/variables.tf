variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project to use"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1"
  description = "GCP region to use"
}

variable "GOOGLE_ZONE" {
  type        = string
  default     = "us-central1-c"
  description = "GCP region to use"
}

variable "GOOGLE_TF_STATE_BUCKET" {
  type        = string
  default     = "kbot-k8s-k3s-bucket"
  description = "GCS bucket for terraform state"
}