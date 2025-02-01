resource "aws_key_pair" "freeswitch" {
  key_name   = "freeswitch_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")  # Change this to your actual public key file

  tags = {
    Name = "freeswitch_key_pair"
  }
}
