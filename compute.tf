variable "project_name" {}
variable "billing_account" {}
variable "region" {}
variable "gce_ssh_user" {}
variable "gce_ssh_pub_key_file" {}

provider "google" {
 region = "${var.region}"
}

data "google_compute_zones" "available" {}

resource "google_compute_firewall" "allow_http" {
    name = "allow-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["http"]
}

resource "google_compute_instance" "web-instance-1" {
 project = "${var.project_name}"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "instance-1"
 machine_type = "f1-micro"
 tags = ["http"]
 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20170328"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
 metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
 }
}

output "instance-1" {
 value = "${google_compute_instance.web-instance-1.network_interface.0.access_config.0.nat_ip}"
}

resource "google_compute_instance" "web-instance-2" {
 project = "${var.project_name}"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "instance-2"
 machine_type = "f1-micro"
 tags = ["http"]
 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20170328"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
 metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
 }
}

output "instance-2" {
 value = "${google_compute_instance.web-instance-2.network_interface.0.access_config.0.nat_ip}"
}

resource "google_compute_instance" "web-instance-3" {
 project = "${var.project_name}"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "instance-3"
 machine_type = "f1-micro"
 tags = ["http"]
 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20170328"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
 metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
 }
}

output "instance-3" {
 value = "${google_compute_instance.web-instance-3.network_interface.0.access_config.0.nat_ip}"
}

resource "google_compute_instance_group" "webservers" {
  project = "${var.project_name}"
  zone = "${data.google_compute_zones.available.names[0]}"
  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = [
    "${google_compute_instance.web-instance-1.self_link}",
    "${google_compute_instance.web-instance-2.self_link}",
    "${google_compute_instance.web-instance-3.self_link}"
  ]

  named_port {
    name = "http"
    port = "80"
  }

}
