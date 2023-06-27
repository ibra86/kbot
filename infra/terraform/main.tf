terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.67.0"
    }
  }
  backend "gcs" {
    bucket = "kbot-k8s-k3s-bucket"
    prefix = "terraform-sops/state"
  }
}

data "google_storage_bucket" "tf_state_bucket" {
  name = "kbot-k8s-k3s-bucket"
}
module "gke_cluster" {
  source         = "../modules/tf-google-gke-cluster-gke-auth"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}

module "github_repository" {
  source                   = "../modules/tf-github-repository"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux-ssh-pub"
}


module "tls_private_key" {
  source    = "../modules/tf-hashicorp-tls-keys"
  algorithm = "RSA"
}

module "flux_bootstrap" {
  source            = "../modules/tf-fluxcd-flux-bootstrap-gke-auth"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  private_key       = module.tls_private_key.private_key_pem

  config_host  = module.gke_cluster.config_host
  config_ca    = module.gke_cluster.config_ca
  config_token = module.gke_cluster.config_token

  github_token = var.GITHUB_TOKEN
}