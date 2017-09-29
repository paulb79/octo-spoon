output "address" {
  value = "${aws_instance.devserver.dns_name}"
}