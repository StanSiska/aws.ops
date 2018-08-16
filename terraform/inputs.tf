provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "vvc.ops"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
