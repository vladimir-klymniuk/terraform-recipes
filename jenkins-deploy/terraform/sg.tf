resource "aws_security_group" "vk-jenkins-sg-web" {
  name = "vk-jenkins-sg"

  # SSH access from anywhere, please use company private network id on non study env.
  ingress {
    from_port   = "${var.server_port_ingress_ssh_port}"
    to_port     = "${var.server_port_ingress_ssh_port}"
    protocol    = "${var.server_port_ingress_ssh_protocol}"
    cidr_blocks = "${var.server_port_ingress_ssh_cidr_blocks_all}"
  }

  # HTTP access from anywhere, allow only http trafic.
  ingress {
    from_port   = "${var.server_port_ingress_http_port}"
    to_port     = "${var.server_port_ingress_jenkins_http_port}"
    protocol    = "${var.server_port_ingress_http_protocol}"
    cidr_blocks = "${var.server_port_ingress_http_cidr_blocks_all}"
  }

  # outbound internet access, allow any output.
  egress {
    from_port   = "${var.server_port_egress_all_port}"
    to_port     =  "${var.server_port_egress_all_port}"
    protocol    =  "${var.server_port_egress_all_protocol}"
    cidr_blocks = "${var.server_port_egress_all_cidr_blocks_all}"
  }

  tags {
    Name = "${var.my_name}-jenkins-sg"
  }

}
