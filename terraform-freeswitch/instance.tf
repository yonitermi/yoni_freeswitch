variable "security_group_id" {}
variable "key_pair_name" {}
variable "eip_allocation_id" {}

resource "aws_instance" "freeswitch" {
  ami             = "ami-0c55b159cbfafe1f0"  # Ubuntu AMI (adjust as needed)
  instance_type   = "t3.medium"
  key_name        = var.key_pair_name
  security_groups = [var.security_group_id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "freeswitch-server"
  }
}

# Attach Elastic IP
resource "aws_eip_association" "freeswitch_eip_attach" {
  instance_id   = aws_instance.freeswitch.id
  allocation_id = var.eip_allocation_id
}
