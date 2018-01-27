
# Get Ubuntu AMI information 
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

# Get Subnet Id for the VPC
data "aws_subnet_ids" "subnets" {
    vpc_id = "${var.vpc_id}"
}

#Jenkins Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins"
  vpc_id      = "${var.vpc_id}"
  
  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all SSH External
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all traffic from HTTP port 8080
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Allow all traffic from HTTP port 80
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allocate the EC2 Jenkins instances 
resource "aws_instance" "jenkins" {
    count         = "${var.jenkins_servers}"
    ami           = "${data.aws_ami.ubuntu.id}"
    instance_type = "${var.instance_type}"

    subnet_id              = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
    key_name               = "${var.default_keypair_name}"
    
    associate_public_ip_address = true 

    tags {
      Owner           = "${var.owner}"
      Name            = "Jenkins-${count.index}"
    }
}

output "jenkins_server_public_ip" {
  value = "${join(",", aws_instance.jenkins.*.public_ip)}"
}