/* region */

provider "aws" {
  region     = "${var.aws_region}"
  profile  = "redjamjar"
}

variable "aws_region" {
  default = "eu-west-2"
}