terraform {
  required_version = ">=1.15.7"
  backend "s3" {
    bucket = "tfstate-140023390772-s3-bucket"
    key = "lock/terraform.tfstate"
    region = "eu-north-1"
    encrypt = true
    use_lockfile = true
 }
}
