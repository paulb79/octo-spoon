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
  key_name      = "developer-key"
  public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa/GfQsHjgN9LtG84j4O5BgfoERvNtt8fIrwanEDP8LndnSrENucnthPZ0cKdXc51GF76oCbGSGDdFQGZwMtxgkyuObO0406HK5Yx2SmjgsqGCznUyHhArIas/rgjSFdvanWt9lJGjzN9JguEfp90ZVVKG/IHiiHSux2wnD2rJl8FIJ+J9LIH81aSzlm9Yvyxu8Og03oycGVvom2Z2bqtiNzWCJAQVeDnF/fqM0gMorhLXifpyPkkq1pPYNcTnI7pOaWbJWLafCA92+Q1IbrQH4iRCD1NxbZtNMcjO6fqSq7BNzEjbdNk8XzXdbZCFGiRX2I8iOgDexFGts9dKVGj7 pbrown@equalexperts.com"
}

resource "aws_instance" "devserver" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  
  connection {
    user = "developer"
  }

  key_name                = "${aws_key_pair.developer.id}"
  vpc_security_group_ids  = ["${aws_security_group.default.id}"]
  subnet_id               = "${aws_subnet.default.id}"

  # ToDo now provision on the instance the kit we need

}


