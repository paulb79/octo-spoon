output "jenkins_profile_name" {
  value = "${aws_iam_instance_profile.jenkins_profile.name}"
}