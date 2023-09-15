# Define the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create a security group to allow incoming/outgoing traffic
resource "aws_security_group" "web" {
  name        = "web"
  description = "Web Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an Elastic IP address
resource "aws_eip" "eipPagoPa" {
  instance = aws_instance.instancePagoPa.id
}

# Launch an EC2 instance
resource "aws_instance" "instancePagoPa" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  
  # Associate the security group and the Elastic IP address
  vpc_security_group_ids = [aws_security_group.web.id]
}
