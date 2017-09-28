provider "aws" {
  region  	 = "${var.region}"
  profile	 = "redjamjar"
}

resource "aws_instance" "bdec-data-viewer" {
  ami           = "ami-996372fd"
  instance_type = "t2.micro"
  key_name		= "${var.key_name}"
}


