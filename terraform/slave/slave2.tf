resource "google_compute_instance" "slave2" {
  name                      = "${var.slave2_name}"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.gcloud_zone}"
  metadata_startup_script   = "${var.startup_script}"

  boot_disk {
    initialize_params {
      image                 = "${var.slave_image}"
    }
  }

  network_interface {
    network                 = "default"
    access_config {
      nat_ip                = "${var.slave2_ip}"
    }
  }

  lifecycle {
    create_before_destroy   = true
  }

  tags = ["philo", "slave", "slave2", "philo-postgres"]

  service_account {
    scopes = ["cloud-platform"]
  }
}
