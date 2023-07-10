resource "google_compute_instance" "vm_instance_2" {
  name = "instance-y"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
        image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  depends_on = [ google_storage_bucket.bucket_2 ]
}
resource "google_storage_bucket" "bucket_2" {
  name = "bucket-exp-2307"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }
}