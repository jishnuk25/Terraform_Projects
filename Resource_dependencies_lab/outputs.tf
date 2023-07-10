output "network_ip" {
  value       = google_compute_instance.vm_instance.instance_id
  description = "Instance id of the vm instance created"
}
output "instance_link" {
  value       = google_compute_instance.vm_instance.self_link
  description = "URI of the created instance"
}
