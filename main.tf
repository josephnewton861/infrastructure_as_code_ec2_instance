provider "aws" {
  region     = "${var.credentials.region}"
  access_key = "${var.credentials.access_key}"
  secret_key = "${var.credentials.secret_access_key}"
}