output "ec2_create_tags" {
  value = "${aws_iam_policy.ec2_create_tags.arn}"
}

output "ec2_describe_all" {
  value = "${aws_iam_policy.ec2_describe_all.arn}"
}

output "ec2_run_instances" {
  value = "${aws_iam_policy.ec2_run_instances.arn}"
}

output "get_user_details" {
  value = "${aws_iam_policy.get_user_details.arn}"
}

output "s3_coderepo_access" {
  value = "${aws_iam_policy.s3_coderepo_access.arn}"
}

output "sg_management" {
  value = "${aws_iam_policy.sg_management.arn}"
}

output "codecommit_read" {
  value = "${aws_iam_policy.codecommit_read.arn}"
}