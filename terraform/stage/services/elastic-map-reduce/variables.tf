variable "aws_region" {
	default = "eu-west-2"
}

variable "key_name" {
  default = "developer"
}

variable "public_key_path" {
  default = "/Users/paulb/.ssh/developer.pub"
}

variable "s3_code_path" {
  default = "s3:///bucket"
}

variable "s3_emr_logs_path" {
  default ="s3:///bucket"
}

variable "s3_data_path" {
  default ="s3:///bucket"
}


