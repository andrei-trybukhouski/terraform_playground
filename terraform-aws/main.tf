terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"

}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
locals {
  ami = data.aws_ami.latest_ubuntu.arn
}
resource "aws_ssm_parameter" "dev_pass" {
  type = "SecureString"
  name = "/dev/pass"
  value = "rs12tr98"
}

data "aws_ssm_parameter" "dev_pass" {
 name = "/dev/pass" 
 depends_on = [
   aws_ssm_parameter.dev_pass
 ]
}

resource "aws_instance" "app_server" {
   count         = 0
  ami           =  data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  user_data = file("userdata")
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "ExampleAppServer"
    Owner = "Andrei Trybukhouski"
    Env = "test"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_sg" {
  dynamic ingress {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge ({
    Name = "ExampleAppServer"
  }, var.common_tags )

}

output "my_instance_id" {
  description = "InstanceID of our server"
  value       = aws_instance.app_server[0].id
}
output "my_instance_ip" {
  description = "IP of our server"
  value       = aws_instance.app_server[0].public_ip
}
output "my_sg_id" {
  description = "ID of sec_grp"
  value       = aws_security_group.web_sg.id
}
output "arn" {
  value = local.ami
}
