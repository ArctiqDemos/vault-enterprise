provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials_file)
}

module "gcp_network" {
  source       = "./modules/gcp-network"
  network_name = var.network_name
  subnet_name  = var.subnet_name
  subnet_cidr  = var.subnet_cidr
  region       = var.region
}

module "gcp_compute" {
  source                = "./modules/gcp-compute"
  instance_name         = var.instance_name
  machine_type          = var.machine_type
  zone                  = var.zone
  image                 = var.image
  subnet_id             = module.gcp_network.subnet_id
  service_account_email = var.service_account_email
}
