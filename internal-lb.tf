resource "google_compute_health_check" "int-lb-health-check" {
  name = "tf-int-lb-health-check"

  http_health_check {}
}

resource "google_compute_region_backend_service" "int-lb" {
  name     = "int-lb"

  backend {
    group = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks = ["${google_compute_health_check.int-lb-health-check.self_link}"]
}

resource "google_compute_forwarding_rule" "int-lb-forwarding-rule" {
  name                  = "int-lb-forwarding-rule"
  load_balancing_scheme = "INTERNAL"
  ports                 = ["80"]
  backend_service       = "${google_compute_region_backend_service.int-lb.self_link}"
}

output "internal_load_balancer_ip" {
  value = "${google_compute_forwarding_rule.int-lb-forwarding-rule.ip_address}"
}

resource "google_compute_instance" "standalone" {
 project = "${var.project_name}"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "standalone"
 machine_type = "f1-micro"
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

output "standalone" {
 value = "${google_compute_instance.standalone.network_interface.0.access_config.0.nat_ip}"
}
