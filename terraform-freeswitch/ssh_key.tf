resource "tls_private_key" "freeswitch_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "freeswitch_key" {
  key_name   = "freeswitch-key"
  public_key = tls_private_key.freeswitch_key.public_key_openssh
}

output "private_key_pem" {
  description = "Private SSH key for accessing the instance"
  value       = tls_private_key.freeswitch_key.private_key_pem
  sensitive   = true
}

output "key_name" {
  description = "Key pair name to attach to EC2 instance"
  value       = aws_key_pair.freeswitch_key.key_name
}
