###
# Setup EMR VPC and Network Access 
###

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "ssh inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = ["aws_subnet.main"]

  tags {
    Name = "${var.project_name} SG"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "EMR Octo Test VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "${var.project_name} Private SN"
  }
}

resource "aws_subnet" "public" {
  vpc_id      = "${aws_vpc.main.id}"
  cidr_block  = "10.0.2.0/24"

  tags {
    Name = "${var.project_name} Public SN"
  } 
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "m" {
  vpc_id = "${aws_vpc.main.id}"

  # Todo create a test to ensure no route exists in the default route table for the vpc to the internet
  
  tags {
    Name = "${var.project_name} VPC Main RT"
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
    Name = "${var.project_name} Private RT"
  }
}

resource "aws_route_table" "p" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project_name} Public RT"
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

###
# END Setup EMR VPC and Network Access 
###