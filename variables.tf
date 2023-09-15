variable "aws_region" {
  description = "The AWS region in which to create the resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
  type        = string
  default     = "YOUR_KEY_NAME"
}

variable "ssh_cidr_block" {
  description = "The IP address for SSH access"
  type        = string
  default     = "YOUR_IP_ADDRESS/32"
}