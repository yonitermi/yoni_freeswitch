resource "aws_eip" "freeswitch" {
  domain = "vpc"

  tags = {
    Name = "freeswitch_EIP"
  }
}
