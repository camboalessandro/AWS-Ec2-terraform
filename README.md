
# AWS EC2 Instance Terraform

Terraform module that provisions an EC2 instance on AWS.

## Prerequisites

1.  AWS account;
2.  AWS CLI installed; 2.2 Follow the official guide for this step: [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3.  Terraform installed; 3.2 Follow the official guide for this step: [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Usage

After successfully installing Terraform and setting up an AWS account, you need to configure AWS access credentials. To do this, run the `aws configure` command in your terminal. You should provide your access credentials (click on your name in the top-right corner of the AWS console and select "My Security Credentials"). In the "Access keys" section, you should see a list of your existing access keys. If this is your first time accessing it, create a new access key.


```
aws configure
AWS Access Key ID:(Write Your Access Key)  
AWS Secret Access Key:(Write Your Secret Access Key)  
Default region name [us-west-2]: us-west-2 (Write your region)  
Default output format [None]: json (write your format)
```

Next, create a Terraform configuration file (`main.tf`) that defines the infrastructure you want to create. In this file, specify resources like EC2 instances, security groups, networks, etc., using the HashiCorp Configuration Language (HCL) syntax. To make your Terraform code flexible and parameterized, allowing you to easily customize resources based on your needs, it's advisable to create a `variables.tf` file.

Navigate to the directory containing your Terraform configuration files and run the `terraform init` command. This command will download the necessary providers and modules for your project.

Run the `terraform apply` command to create or modify resources in the cloud environment. Terraform will ask for confirmation before proceeding.

To delete the created resources, run the `terraform destroy` command.
## main\.tf file
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

## Deployment of a Python microservice

After creating the EC2 instance, we deploy a simple Python service.

1. Connect to the machine via SSH: `ssh -i KEY.pem ubuntu@ELASTIC_IP`.
2. Run `sudo apt-get update`.
3. Install Python 3 and pip: `sudo apt install python3-pip`.
4. Install Flask: `pip3 install Flask`.
5. Create a Python file: `touch ms.py`.
6. Paste the code below into `ms.py`:
   ```python
   from flask import Flask
   app = Flask(__name__)
   @app.route('/')
   def hello_world():
       return 'Hello World!'
   if __name__ == '__main__':
       app.run(host='0.0.0.0', port=8080)
   ```
7. Send a GET request to receive the response. 😉
