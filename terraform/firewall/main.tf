resource "google_compute_firewall" "haproxy" {
  name        = "philo-haproxy"
  description = "Allow Connection to haproxy"
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["1936"]
  }

  target_tags   = ["philo-haproxy"]
}

resource "google_compute_firewall" "postgres" {
  name        = "philo-postgres"
  description = "Allow Connection to postgres"
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  target_tags   = ["philo-postgres"]
}
