provider "aws" {
  region  	 = "${var.aws_region}"
  profile	 = "redjamjar"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant VPC internet access
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Subnet for our instances
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# SSH Access from anywhere
resource "aws_security_group" "default" {
  name          = "research_example"
  vpc_id        = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks  = ["0.0.0.0/0"]

  }
}

resource "aws_key_pair" "developer" {
  key_name      = "${var.key_name}"
  public_key    = "${file(var.public_key_path)}"
}

resource "aws_instance" "devserver" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  

  key_name                = "${aws_key_pair.developer.id}"
  vpc_security_group_ids  = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default.id}"

  # ToDo 1. now provision on the instance the kit we need
  # ToDo 2. now provision EMR
  # ToDo 3. connect to s3 buckets

  tags {
    name      = "octo-dev-server"
  }

}


