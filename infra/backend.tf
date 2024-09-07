terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-latam_test"
    prefix = "terraform/state"
    credentials = "/home/federico/repos/me/latam-test-434700-38550ce792bf.json"
  }
}