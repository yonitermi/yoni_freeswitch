resource "aws_instance" "freeswitch" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.freeswitch_key.key_name
  subnet_id       = var.subnet_id
  vpc_security_group_ids = [aws_security_group.freeswitch_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "FreeSWITCH-Server"
  }
}
