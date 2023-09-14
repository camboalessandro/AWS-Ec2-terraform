
# AWS EC2 Instance Terraform

Terraform module that provisions an EC2 instance on AWS.

## Prerequisites

1.  AWS account;
2.  AWS CLI installed; 2.2 Follow the official guide for this step: [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3.  Terraform installed; 3.2 Follow the official guide for this step: [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Usage

After successfully installing Terraform and setting up an AWS account, you need to configure AWS access credentials. To do this, run the `aws configure` command in your terminal. You should provide your access credentials (click on your name in the top-right corner of the AWS console and select "My Security Credentials"). In the "Access keys" section, you should see a list of your existing access keys. If this is your first time accessing it, create a new access key.

mathematicaCopy code

`$ aws configure
AWS Access Key ID:(Write Your Access Key)  
AWS Secret Access Key:(Write Your Secret Access Key)  
Default region name [us-west-2]: us-west-2 (Write your region)  
Default output format [None]: json (write your format)` 

Next, create a Terraform configuration file (`main.tf`) that defines the infrastructure you want to create. In this file, specify resources like EC2 instances, security groups, networks, etc., using the HashiCorp Configuration Language (HCL) syntax. To make your Terraform code flexible and parameterized, allowing you to easily customize resources based on your needs, it's advisable to create a `variables.tf` file.

Navigate to the directory containing your Terraform configuration files and run the `terraform init` command. This command will download the necessary providers and modules for your project.

Run the `terraform apply` command to create or modify resources in the cloud environment. Terraform will ask for confirmation before proceeding.

To delete the created resources, run the `terraform destroy` command.
## main(.tf) file
```
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
    from_port   = 80
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
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an Elastic IP address
resource "aws_eip" "example" {
  instance = aws_instance.example.id
}

# Launch an EC2 instance
resource "aws_instance" "example" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  
  # Associate the security group and the Elastic IP address
  vpc_security_group_ids = [aws_security_group.web.id]
}

output "public_ip" { 
	value = aws_eip.example_eip.public_ip 
	}
```

## variables(.tf) file
```
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
```