provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-east-1"
}

resource "aws_instance" "nycOpenData" {
  ami           = "ami-07eb698ce660402d2"
  instance_type = "m5.large"
  key_name = "rdm-ssh"
  vpc_security_group_ids = ["${aws_security_group.jupyter_notebook_sg.id}"]

  provisioner "file" {
    source      = "configure.sh"
    destination = "/tmp/configure.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.aws/rdm-ssh.pem")}"
      }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure.sh",
      "/tmp/configure.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.aws/rdm-ssh.pem")}"
    }
  }
}

# permit inbound access to all the ports we need
resource "aws_security_group" "jupyter_notebook_sg" {
  # name   = "jupyter_notebook_sg"
  # vpc_id = "${aws_vpc.tf.id}"

  # jupyter uses 8888 by default
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH uses 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow everything outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# store ip for output
resource "aws_eip" "ip" {
  instance = "${aws_instance.nycOpenData.id}"
}

output "node_dns_name" {
  value = "${aws_instance.nycOpenData.public_dns}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

