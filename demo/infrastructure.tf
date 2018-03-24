provider "google" {
  credentials = "${file("key.json")}"
  project = "control-theory"
  region = "us-central1"
}

resource "google_compute_network" "demo" {
  name = "control"
}

resource "google_compute_subnetwork" "monitoring" {
  name = "monitoring"
  region = "us-central1"
  network = "${google_compute_network.demo.self_link}"
  ip_cidr_range = "10.129.0.0/24"
}

resource "google_compute_subnetwork" "cluster" {
  name = "cluster"
  region = "us-central1"
  network = "${google_compute_network.demo.self_link}"
  ip_cidr_range = "10.128.0.0/16"
}

resource "google_container_cluster" "demo" {
  name = "demo"
  zone = "us-central1-a"
  initial_node_count = 6

  master_auth {
    username = "test"
    password = "test"
  }


  node_config {
    machine_type = "n1-standard-4"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  network = "${google_compute_network.demo.name}"
  subnetwork = "${google_compute_subnetwork.cluster.name}"
}
