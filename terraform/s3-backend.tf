terraform {
  backend "s3" {
		bucket 	= "octo-spoon-research"
		region 	= "eu-west-2"
		key		  = "terraform.tfstate"
    profile = "redjamjar"
	}
}