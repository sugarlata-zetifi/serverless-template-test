terraform {
  backend "s3" {
    bucket = "terraform-841079562861-sls"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}