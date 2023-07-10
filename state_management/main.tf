provider "google" {
  project = "terraform-390705"
  region  = "us-central-1"
}
resource "google_storage_bucket" "bucket_state_store" {
  name                        = "terraform-390705"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
}
# terraform {
#   backend "gcs" {
#     bucket = "terraform-390705"
#     prefix = "terraform/state"
#   }
# }
terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}