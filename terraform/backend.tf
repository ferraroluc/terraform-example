terraform {
  backend "s3" {
    bucket = "example-remote-status"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}