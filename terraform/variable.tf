variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable default_keypair_name {
  description = "Name of the KeyPair used for all nodes"
  default = "Opsschool-1"
}
variable instance_type {
  default = "t2.small"
}

variable jenkins_servers {
  default = "2"
}

variable owner {
  default = "Jenkins"
}

variable vpc_id {
  default = "vpc-584d6e20"
}