provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      terraform-managed = true
    }
  }
}

terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      version = "~> 5.10"
    }
  }
}