variable "profile" {
  default = "pbrowndev"
}

output "profile" {
  value = "${var.profile}"
}

variable "aws_region" {
  default = "eu-west-2"
}

output "aws_region" {
  value = "${var.aws_region}"
}

variable "project_name" {
  default = "Octo-jenkins"
}

output "project_name" {
  value = "${var.project_name}"
}

variable "key_name" {
  default = "Jenkins"
}

output "key_name" {
  value = "${var.key_name}"
}