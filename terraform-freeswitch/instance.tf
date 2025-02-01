resource "aws_instance" "freeswitch" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Choose a valid AMI
  instance_type          = "t3.medium"
  key_name               = var.key_name  # Use key pair output
  vpc_security_group_ids = [var.security_group_id]  # Use SG output

  tags = {
    Name = "FreeSWITCH-Server"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.freeswitch.id
  allocation_id = var.eip_id  # Use allocated EIP from previous stage
}
