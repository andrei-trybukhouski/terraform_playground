terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
  /*
  backend "s3" {
    bucket = "andrei-trybukhouski-test-project-terraform"
    key    = "test/terraform.tfstate"
    region = "eu-central-1"
  }
  */
}
provider "aws" {
  profile = "default"
  region  = "eu-central-1"

}

resource "aws_instance" "vpn1" {
  instance_type = "t2.micro"
  ami           = "ami-0502e817a62226e03"
  tags = {
    "Name" = "vpn-1-frankfurt"
  }
}
