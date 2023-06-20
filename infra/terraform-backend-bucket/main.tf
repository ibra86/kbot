
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }
}

provider "google" {
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

resource "google_storage_bucket" "tf_state_bucket" {
  name     = "kbot-k8s-k3s-bucket"
  location = var.GOOGLE_REGION
  project  = var.GOOGLE_PROJECT
  uniform_bucket_level_access = true
}