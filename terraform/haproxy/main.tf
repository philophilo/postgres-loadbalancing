resource "google_compute_instance" "haproxy" {
  name                      = "${var.haproxy_name}"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.gcloud_zone}"
  metadata_startup_script   = "${var.startup_script}"

  boot_disk {
    initialize_params {
      image                 = "${var.haproxy_image}"
    }
  }

  network_interface {
    network                 = "default"
    access_config {
      nat_ip                = "${var.haproxy_ip}"
    }
  }

  lifecycle {
    create_before_destroy   = true
  }
    
  metadata {
    MASTER_IP               = "${var.master_ip}"
    SLAVE1_IP               = "${var.slave1_ip}"
    SLAVE2_IP               = "${var.slave2_ip}"
    HAPROXY_USERNAME        = "${var.haproxy_username}"
    HAPROXY_PASSWORD        = "${var.haproxy_password}"
  }

  tags = ["philo", "philo-haproxy"]

  service_account {
    scopes = ["cloud-platform"]
  }
}
