output "public_ip" {
  description = "Public IP of the FreeSWITCH EC2 instance"
  value       = aws_instance.freeswitch.public_ip
}

output "instance_id" {
  description = "Instance ID of the deployed FreeSWITCH server"
  value       = aws_instance.freeswitch.id
}
