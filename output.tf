output "instance-id" {
  description = "The EC2 instance ID"
  value       = "${aws_instance.example2.id}"
}


output "Elastic-IP" {
  description = "EIP"
  value       = "${aws_eip.example.public_ip }"
}