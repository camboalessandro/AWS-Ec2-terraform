output "instance-id" {
  description = "The EC2 instance ID"
  value       = "${aws_instance.instancePagoPa.id}"
}


output "Elastic-IP" {
  description = "EIP"
  value       = "${aws_eip.eipPagoPa.public_ip }"
}