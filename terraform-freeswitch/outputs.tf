output "instance_id" {
  description = "ID of the FreeSWITCH EC2 instance"
  value       = aws_instance.freeswitch.id
}

output "instance_public_ip" {
  description = "Public IP assigned to the instance"
  value       = aws_eip.freeswitch_eip.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.freeswitch.private_ip
}
