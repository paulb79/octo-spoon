/* Jenkins Server */

module "vpc" {
  source = "../vpc/"
}

module "global" {
  source = "../../global"
}

provider "aws" {
  region   = "${module.global.aws_region}"
  profile  = "${module.global.profile}"
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
  key_name          = "${module.global.key_name}"
  
  subnet_id         = "${module.vpc.private_subnet}"

  vpc_security_group_ids = ["${module.vpc.jenkins_sg_id}"]

  tags {
    Name = "octo-jenkins-{{timestamp}}"
  }
}

output "address" {
  value = "${aws_instance.jenkins.public_ip}"
}