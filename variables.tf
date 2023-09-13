variable "aws_region" {
  description = "La regione AWS in cui creare le risorse."
  type        = string
  default     = "us-east-1"
}

variable "instance_ami" {
  description = "L'ID AMI per l'istanza EC2."
  type        = string
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "Il tipo di istanza EC2 da avviare."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Il nome della coppia di chiavi SSH da utilizzare."
  type        = string
  default     = "awsTFV"
}

variable "ssh_cidr_block" {
  description = "L'indirizzo IP CIDR per l'accesso SSH."
  type        = string
  default     = "2.32.236.253/32"
}