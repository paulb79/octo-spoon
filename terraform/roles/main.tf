data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jenkins" {
  name               = "jenkins_bob"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}



resource "aws_iam_instance_profile" "jenkins_profile" {
  name  = "jenkins_profile"
  role = "${aws_iam_role.jenkins.name}"
}


module "policies" {
  source = "../policies"
}


resource "aws_iam_role_policy_attachment" "attach_ec2_create_tags_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.ec2_create_tags}"
}

resource "aws_iam_role_policy_attachment" "attach_ec2_describe_all_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.ec2_describe_all}"
}

resource "aws_iam_role_policy_attachment" "attach_ec2_run_instances_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.ec2_run_instances}"
}

resource "aws_iam_role_policy_attachment" "attach_get_user_details_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.get_user_details}"
}

resource "aws_iam_role_policy_attachment" "attach_s3_coderepo_access_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.s3_coderepo_access}"
}

resource "aws_iam_role_policy_attachment" "attach_sg_manaagement_policy" {
  role       = "${aws_iam_role.jenkins.name}"
  policy_arn = "${module.policies.sg_management}"
}

