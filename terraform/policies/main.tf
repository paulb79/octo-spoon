
module "global" {
  source = "../global"
}

provider "aws" {
  region   = "${module.global.aws_region}"
  profile  = "${module.global.profile}"
}


resource "aws_iam_policy" "ec2_describe_all" {
  name = "ec2_describe_all"
  description = "Describe all EC2 resources"
  policy =  "${file("${path.module}/ec2_describe_all.json")}"
}

resource "aws_iam_policy" "ec2_run_instances" {
  name = "ec2_run_instances"
  description = "Run EC2 instances"
  policy =  "${file("${path.module}/ec2_run_instances.json")}"
}

resource "aws_iam_policy" "get_user_details" {
  name = "get_user_details"
  description = "Get user details"
  policy =  "${file("${path.module}/get_user_details.json")}"
}

resource "aws_iam_policy" "ec2_create_tags" {
  name = "ec2_create_tags"
  description = "Create EC2 tags"
  policy =  "${file("${path.module}/ec2_create_tags.json")}"
}

resource "aws_iam_policy" "sg_management" {
  name = "sg_management"
  description = "Manage Security Groups"
  policy =  "${file("${path.module}/sg_management.json")}"
}

resource "aws_iam_policy" "s3_coderepo_access" {
  name = "s3_coderepo_access"
  description = "Access S3 code repository bucket"
  policy =  "${file("${path.module}/s3_coderepo_access.json")}"
}