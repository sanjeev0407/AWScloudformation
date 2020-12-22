provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA3R4V7QUBGBU24SWX"
  secret_key = "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"
}
resource "aws_instance" "server" {
  ami                = "ami-04d29b6f966df1537"
  count=2
  instance_type      = "t2.micro"
  subnet_id          = "subnet-0266d7de583267213"
  security_groups = ["sg-05517bd7da1308712"]
  key_name           = "sanjukey"

  tags = {
    Name = "sanjeev-server"
  }
}
