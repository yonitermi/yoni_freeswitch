resource "aws_eip" "freeswitch_eip" {
  domain   = "vpc"
  tags = {
    Name = "FreeSWITCH-Static-IP"
  }
}
