
variable "aws_region" {
	default = "eu-west-2"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-785db401"
    eu-west-2 = "ami-996372fd"
  }
}