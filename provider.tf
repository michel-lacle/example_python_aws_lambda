terraform {
  required_providers {
    aws = "~> 2.59.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "archive" {}