provider "google" {
  region = us-central1
}
module "web_server" {
  source = "./server"
}
module "server_network" {
  source = "./network"
}