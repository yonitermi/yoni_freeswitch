output "security_group_id" {
  value = aws_security_group.voip_server.id
}

output "key_pair_name" {
  value = aws_key_pair.freeswitch.key_name
}

output "eip_allocation_id" {
  value = aws_eip.freeswitch.id
}
