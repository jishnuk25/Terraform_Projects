terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      # version = "4.70.0"
    }
  }
}

provider "google" {
  project = "terraform-390705"
  region  = "us-central1"
}