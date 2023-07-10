variable "instance_name" {
  type        = string
  description = "Name for the compute instance"
  default = "instance-x"
}
variable "instance_zone" {
  type        = string
  description = "Zone for the compute instance"
  default = "us-east1-b"
}
variable "instance_type" {
  type        = string
  description = "Disk type of the compute instance"
  default     = "n1-standard-1" # optional, defaults to n1-standard-2 if not specified. Must
}