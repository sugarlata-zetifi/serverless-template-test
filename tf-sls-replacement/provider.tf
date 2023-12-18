provider "aws" {
  region = "ap-southeast-2"
  profile = "nathan-sandbox"

  default_tags {
    tags = {
      terraform-managed = true
    }
  }
}

terraform {
  required_version = "~> 1.6"

  required_providers {
    aws = {
      version = "~> 5.10"
    }
  }
}