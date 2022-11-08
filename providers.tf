terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1" #deplpoy in Ireland
}












