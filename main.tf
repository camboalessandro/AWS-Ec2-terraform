# Definisci il provider AWS
provider "aws" {
  region = "us-east-1" # Cambia con la tua regione desiderata
}

# Crea un gruppo di sicurezza per consentire il traffico in ingresso
resource "aws_security_group" "web" {
  name        = "web"
  description = "Web Security Group"
  
  # Consenti il traffico HTTP e SSH in ingresso (personalizza secondo le tue esigenze)
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
    cidr_blocks = ["2.32.236.253/32"] # Sostituisci con il tuo indirizzo IP per l'accesso SSH
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

# Crea un indirizzo IP elastico
resource "aws_eip" "example" {
	instance = aws_instance.example.id
}

# Avvia un'istanza EC2
resource "aws_instance" "example" {
  ami           = "ami-053b0d53c279acc90" # Sostituisci con l'AMI desiderato
  instance_type = "t2.micro"               # Adatta alle tue esigenze
  key_name      = "awsTFV"     # Sostituisci con la tua coppia di chiavi SSH

  # Collega il gruppo di sicurezza e l'indirizzo IP elastico
  vpc_security_group_ids = [aws_security_group.web.id]
#  associate_public_ip_address = true

  # Puoi aggiungere dati utente o provisioners qui per configurare il tuo microservizio
}

# Visualizza l'indirizzo IP pubblico
output "public_ip" {
  value = aws_instance.example.public_ip
}
