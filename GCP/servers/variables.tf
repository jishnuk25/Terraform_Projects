variable "bucket_region" {
  type = string
  description = "region for the bucket"
  default = "US"
  sensitive = true
}

//can be called using var.bucket_region