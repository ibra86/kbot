
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

locals {
  github_repository_name = "ibra86/kbot"
}

resource "google_service_account" "sa" {
  project      = var.GOOGLE_PROJECT
  account_id   = "github-actions-sa-2"
  display_name = "Github Actions SA 2"
  description  = "for Workload Identity Pool used by GitHub Actions"
}

resource "google_iam_workload_identity_pool" "pool" {
  project                   = var.GOOGLE_PROJECT
  workload_identity_pool_id = "sops-pool-2"
  display_name              = "SOPS pool 2"
  description               = "for GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "pool-provider" {
  project                            = var.GOOGLE_PROJECT
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "sops-wip-provider-2"
  display_name                       = "SOPS provider 2"
  description                        = "For Github actions"
  attribute_mapping = {
    "google.subject"       = "assertion.sub",
    "attribute.repository" = "assertion.repository",
    "attribute.actor"      = "assertion.actor"       
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

data "google_kms_key_ring" "key_ring" {
  name     = "sops-flux-2"
  location = "global"
}

data "google_kms_crypto_key" "crypto_key" {
  name     = "sops-key-flux"
  key_ring = data.google_kms_key_ring.key_ring.id
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {

  crypto_key_id = data.google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
        "serviceAccount:${google_service_account.sa.email}",
    ]
}

resource "google_service_account_iam_binding" "github-actions-iam" {
  service_account_id = google_service_account.sa.id
  role               = "roles/iam.workloadIdentityUser"

  members = [
   "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${local.github_repository_name}",
  ]
}
