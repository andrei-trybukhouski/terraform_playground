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

resource "aws_instance" "app_server" {
  // count         = 1
  ami           = "ami-0502e817a62226e03"
  instance_type = "t2.micro"
  user_data = file("userdata")
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "ExampleAppServer"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_sg" {
  dynamic "ingress" {
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
  tags = {
    Name = "ExampleAppServer"
  }
}

output "my_instance_id" {
  description = "InstanceID of our server"
  value       = aws_instance.app_server.id
}
output "my_instance_ip" {
  description = "IP of our server"
  value       = aws_instance.app_server.public_ip
}
output "my_sg_id" {
  description = "ID of sec_grp"
  value       = aws_security_group.web_sg.id
}
