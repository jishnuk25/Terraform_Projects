resource "google_storage_bucket" "mybucket" {
  name          = "bucket001914"
  location      = var.bucket_region
  storage_class = "STANDARD"
}

resource "google_compute_instance" "myinstance" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220607"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}
