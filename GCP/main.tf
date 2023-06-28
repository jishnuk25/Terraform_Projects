provider "google" {
  project = "terraform-390705"
  region  = "us-central1"
}

resource "google_compute_instance_template" "template" {
  name        = "my-instance-template"
  description = "Instance template for Tomcat instances"
  project     = "terraform-390705"
  region      = "us-central1"
  machine_type = "n1-standard-1"
  disk {
    source_image   = "Ubuntu:20.04-LTS"
  }
  properties {
    metadata_startup_script = <<EOF
#!/bin/bash
apt-get update
apt-get install -y tomcat9
EOF

    tags = ["tomcat"]

    // Add any other necessary instance configuration here
    // For example, you can specify boot disk, network, etc.
  }
}

resource "google_compute_instance_group_manager" "autoscaler" {
  name               = "my-autoscaler"
  base_instance_name = "my-instance"
  zone               = "us-central1-a"
  target_size        = 2

  version {
    name              = "v1"
    instance_template = google_compute_instance_template.template.self_link
  }

  named_port {
    name = "http"
    port = 8080
  }

  autoscaling_policy {
    min_num_replicas = 2
    max_num_replicas = 4

    cpu_utilization {
      target_utilization = 0.6
    }
  }
}

resource "google_compute_backend_service" "backend_service" {
  name        = "my-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  backends    = [google_compute_instance_group_manager.autoscaler.instance_group]

  health_checks = ["${google_compute_health_check.health_check.self_link}"]
}

resource "google_compute_http_health_check" "health_check" {
  name               = "my-health-check"
  port               = 8080
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 5
}

resource "google_compute_url_map" "url_map" {
  name        = "my-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name        = "my-target-proxy"
  url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name        = "my-forwarding-rule"
  port_range  = "80"
  target      = google_compute_target_http_proxy.target_proxy.self_link
}
