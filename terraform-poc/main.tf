resource "google_compute_network" "vpc_network" {
    name = "terraform_vpc_1"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_1" {
    name = "subnet-asia-south1"
    ip_cidr_range = var.ip_cidr_range
    region = "asia-south1"
    network = google_compute_network.vpc_network.id
    private_ip_google_access = true
}
resource "google_compute_firewall" "allow_ports" {
    name = "allow-ports"
    network = google_compute_network.vpc_network.name
    allow {
      protocol = "tcp"
      ports = [ "80" ]
    }
    source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "demo-poc-1" {
    name = "demo-poc-1"
    machine_type = "e2-medium"
    zone = var.zone

    boot_disk {
      initialize_params {
        image = "debian-12-bookworm-v20260417"
        size = 30
      }
    }
    network_interface {
      network = google_compute_network.vpc_network.name
      access_config {}
    }
    metadata_startup_script = file("scripts/startup.sh")
    tags = ["assess-poc-app"]
}
