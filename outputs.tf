output "address" {
  value = "${aws_instance.bdec.dns_name}"
}