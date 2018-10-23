provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-1"
}

resource "aws_instance" "nycOpenData" {
  ami           = "ami-07eb698ce660402d2"
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.nycOpenData.id}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

