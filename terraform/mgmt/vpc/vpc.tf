module "global" {
  source = "../../global"
}

resource "aws_security_group" "jenkins" {
  name        = "octo-jenkins-sg"
  description = "Jenkins and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["163.171.33.0/24"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["163.171.33.0/24"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["163.171.33.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${module.global.project_name} SG"
  }
}

output jenkins_sg_id {
  value = "${aws_security_group.jenkins.id}"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "${module.global.project_name} VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "${module.global.project_name} Private SN"
  }
}

resource "aws_subnet" "public" {
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${module.global.project_name} Public SN"
  } 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${module.global.project_name} Gatweay"
  }
}

resource "aws_route_table" "m" {
  vpc_id = "${aws_vpc.main.id}"

  # Todo create a test to ensure no route exists in the default route table for the vpc to the internet
  
  tags {
    Name = "${module.global.project_name} VPC Main RT"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  # Todo provide a route for private instances to get to the internet (remove when using packer)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  
  tags {
    Name = "${module.global.project_name} Private RT"
  }
}

resource "aws_route_table" "p" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${module.global.project_name} Public RT"
  }
}


resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.m.id}"
}

resource "aws_route_table_association" "r" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "p" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.p.id}"
}


output "private_subnet" {
  value = "${aws_subnet.main.id}"
}

output "public_subnet" {
  value = "${aws_subnet.public.id}"
}
###
# END Setup EMR VPC and Network Access 
###