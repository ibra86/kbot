variable "GOOGLE_PROJECT" {
  type        = string
  description = "GCP project to use"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1"
  description = "GCP region to use"
}

variable "TELE_TOKEN" {
  type        = string
  description = "kbot TELE_TOKEN"
}
