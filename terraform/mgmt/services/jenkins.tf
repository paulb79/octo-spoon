/* Jenkins Server */

module "vpc" {
  source = "../vpc/"
}

module "global" {
  source = "../../global"
}

variable "key_name" {
  default = "Jenkins"
}

provider "aws" {
  region   = "${var.aws_region}"
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



# Create a web server
resource "aws_instance" "jenkins" {
  # ...
  ami               = "${data.aws_ami.octo.id}"
  instance_type     = "t2.medium"
  key_name          = "${var.key_name}"
  security_groups   = ["${module.global.jenkins_sg}"]
  subnet_id         = "${module.vpc.private_subnet}"

  tags {
    Name = "octo-jenkins-{{timestamp}}"
  }
}

output "address" {
  value = "${aws_instance.jenkins.public_ip}"
}