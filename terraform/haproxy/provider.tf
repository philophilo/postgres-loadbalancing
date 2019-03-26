provider "google" {
    version     = "<= 1.8"
    credentials = "${var.service_account_path}"
    project     = "${var.project_id}"
    region      = "${var.region}"
    zone        = "${var.gcloud_zone}"
}
