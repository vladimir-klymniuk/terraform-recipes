provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "vk-jenkins-server" {

  ami           = "${var.base_ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.vk-jenkins-sg.id}"]

  tags {
    Name = "${var.my_name}"
  }

  provisioner "file" {
    connection {
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }

    source      = "docker/docker-compose.yaml"
    destination = "/home/ec2-user/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    connection {
      user        = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }

    inline = [
      "sudo su",
      "sudo yum install -y docker",
      "sudo usermod -aG docker ec2-user",
      "sudo service docker start",
      "curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m)  --output docker-compose",
      "sudo mv docker-compose /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo chmod +x docker-compose.yaml",
      "mkdir data",
      "docker-compose --version",
      "docker-compose -f /home/ec2-user/docker-compose.yaml up -d"
    ]
  }

}
