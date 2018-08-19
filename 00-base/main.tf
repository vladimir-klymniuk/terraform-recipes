provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

data "aws_ami" "debian" {
  filter {
    name   = "state"
    values = ["available"]
  }

  most_recent = true

  filter {
    name   = "name"
    values = ["debian-jessie-amd64-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "debian" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "${var.instance_type}"
  count =         "${var.instance_count}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.hw-vk.id}"]

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }
}

