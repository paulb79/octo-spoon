output "address" {
  value = "${aws_instance.devserver.public_ip}"
}

output "key_name" {
  value = "${aws_instance.devserver.key_name}"
}