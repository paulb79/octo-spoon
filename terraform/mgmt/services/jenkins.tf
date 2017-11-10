/* Jenkins Server */

module "vpc" {
  source = "../vpc/"
}

module "global" {
  source = "../../global"
}

module "roles" {
  source = "../../roles"
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

  owners = ["105761026190", "861059892590"] # EE BDEC & HMRC BDEC Account
}

# Create a web server
resource "aws_instance" "jenkins" {
  # ...
  ami                     = "${data.aws_ami.octo.id}"
  instance_type           = "t2.medium"
  key_name                = "${module.global.key_name}"
  subnet_id               = "${module.vpc.public_subnet}"
  iam_instance_profile    = "${module.roles.jenkins_profile_name}"
  vpc_security_group_ids  = ["${module.vpc.jenkins_sg_id}"]

  tags {
    Name = "octo-jenkins-${timestamp()}"
  }
}

output "address" {
  value = "${aws_instance.jenkins.public_dns}"
}


