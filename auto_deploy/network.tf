resource "google_compute_network" "network_x" {
  name                    = "network-x-1"
  auto_create_subnetworks = "true"
}
resource "google_compute_firewall" "network-x-1-allow-http-ssh-rdp-icmp" {
  name    = "firewall-x-1"
  network = google_compute_network.network_x.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}
module "mynet-us-vm" {
  source           = "./instance"
  instance_name    = "mynet-us-vm"
  instance_zone    = "us-east1-b"
  instance_network = google_compute_network.network_x.self_link
}
module "mynet-eu-vm" {
  source           = "./instance"
  instance_name    = "mynet-eu-vm"
  instance_zone    = "europe-west1-d"
  instance_network = google_compute_network.network_x.self_link
}
