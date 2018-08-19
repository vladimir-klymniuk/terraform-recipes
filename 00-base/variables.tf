variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "region" {
  default = "eu-west-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "my_name" {
  type        = "string"
  default     = "vklymniuk"
  description = "My instance tag name"
}

variable "key_name" {
  type        = "string"
  description = "SSH pair key name."
  default     = "vk-key"
}

variable "instance_count" {
  type        = "string"
  description = "Count of instance. (advanced+)"
  default     = 2
}

#### Income SSH conncetions configuration variables.
variable "server_port_ingress_ssh_port" {
  type        = "string"
  description = "The HTTP connections server port configuration will use for security group setup."
  default     = 22
}

variable "server_port_ingress_ssh_protocol" {
  type        = "string"
  description = "The HTTP connections server protocol configuration will use for security group setup."
  default     = "tcp"
}

variable "server_port_ingress_ssh_cidr_blocks_all" {
  description = "The HTTP connections server cidr_blocks configuration will use for security group setup."
  default     = ["0.0.0.0/0"]
  type        = "list"
}
####

#### Income HTTP trafic conncetions configuration variables.
variable "server_port_ingress_http_port" {
  description = "The HTTP connections server port configuration will use for security group setup."
  default     = 80
  type        = "string"
}

variable "server_port_ingress_http_protocol" {
  description = "The HTTP connections server protocol configuration will use for security group setup."
  default     = "tcp"
  type        = "string"
}

variable "server_port_ingress_http_cidr_blocks_all" {
  type        = "list"
  description = "The HTTP connections server cidr_blocks configuration will use for security group setup."
  default     = ["0.0.0.0/0"]
}
####

#### Output configuration variables.
variable "server_port_egress_all_port" {
  description = "The output connections server port configuration will use for security group setup."
  default     = 0
  type        = "string"
}

variable "server_port_egress_all_protocol" {
  description = "The output connections server port configuration will use for security group setup."
  default     = "-1"
  type        = "string"
}

variable "server_port_egress_all_cidr_blocks_all" {
  description = "The output connections server cidr_blocks configuration will use for security group setup."
  type        = "list"
  default     = ["0.0.0.0/0"]
}
####