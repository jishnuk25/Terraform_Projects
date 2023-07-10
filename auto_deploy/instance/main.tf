resource "google_compute_instance" "VM_Instance" {
  name = "${var.instance_name}"
  zone = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    access_config {
      
    }
    network = "${var.instance_network}"
  }
}