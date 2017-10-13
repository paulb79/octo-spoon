/* Jenkins Server */

variable "key_name" {
  default = "Jenkins"
}
variable "profile" {
  default = "pbrowndev"
}

# Configure the AWS Provider

provider "aws" {
  region   = "eu-west-2"
  profile  = "${var.profile}"
}

data "aws_ami" "octo" {
  most_recent = true

  filter {
    name   = "name"
    values = ["octo-pkt-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["105761026190"] # EE
}

resource "aws_security_group" "jenkins" {
  name        = "octo-jenkins-sg"
  description = "Jenkins and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Octo Jenkins SG"
  }
}

# Create a web server
resource "aws_instance" "jenkins" {
  # ...
  ami               = "${data.aws_ami.octo.id}"
  instance_type     = "t2.medium"
  key_name          = "${var.key_name}"
  security_groups   = ["${aws_security_group.jenkins.name}"]

  tags {
    Name = "octo-jenkins-{{timestamp}}"
  }
}

output "address" {
  value = "${aws_instance.jenkins.public_ip}"
}