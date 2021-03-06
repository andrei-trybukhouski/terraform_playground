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

resource "aws_key_pair" "key1" {
  key_name   = "frankfurt1-${var.project_name}"
  public_key = file("id_rsa.pub")

} 

resource "aws_ssm_parameter" "dev_pass" {
  type  = "SecureString"
  name  = "/dev/pass"
  value = "rs12tr98"
}

data "aws_ssm_parameter" "dev_pass" {
  name = "/dev/pass"
  depends_on = [
    aws_ssm_parameter.dev_pass
  ]
}

resource "aws_eip" "lb" {
  instance = aws_instance.app_server[0].id
  vpc      = true

}


resource "aws_instance" "app_server" {
  count                  = var.serverscount
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  user_data              = file("userdata")
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = merge({
    Name = "ExampleAppServer"
  }, var.common_tags)
  key_name = aws_key_pair.key1.key_name
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
  tags = merge({
    Name = "ExampleAppServer"
  }, var.common_tags)

}
