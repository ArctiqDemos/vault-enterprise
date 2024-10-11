resource "google_compute_network" "vault_network" {
  name       = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vault_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vault_network.id
}

resource "google_compute_firewall" "vault_firewall" {
  name    = "vault-firewall"
  network = google_compute_network.vault_network.id

  allow {
    protocol = "tcp"
    ports    = ["8200", "8201"]
  }

  source_ranges = ["0.0.0.0/0"]
}
