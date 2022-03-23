terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.14.0"
    }
  }
}

provider "google" {
  credentials = file("example.json")

  project = "example-project"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "gcp_network" "default" {
  auto_create_subnetworks         = "false"
  delete_default_routes_on_create = "false"
  description                     = "Default network for the project"
  mtu                             = "0"
  name                            = "default"
  project                         = "example-project"
  routing_mode                    = "REGIONAL"
}

resource "gcp_firewall" "default-allow-ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "default-allow-ssh"
  network       = "${data.terraform_remote_state.local.outputs.google_compute_network_default_self_link}"
  priority      = "1000"
  project       = "example-project"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-server"]
}
