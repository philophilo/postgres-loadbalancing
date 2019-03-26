resource "google_compute_instance" "master" {
  name                      = "${var.master_name}"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.gcloud_zone}"
  metadata_startup_script   = "${var.startup_script}"

  boot_disk {
    initialize_params {
      image                 = "${var.master_image}"
    }
  }

  network_interface {
    network                 = "default"
    access_config {
      nat_ip                = "${var.master_ip}"
    }
  }

  lifecycle {
    create_before_destroy   = true
  }

  tags = ["philo", "philo-postgres"]

  service_account {
    scopes = ["cloud-platform"]
  }
}
