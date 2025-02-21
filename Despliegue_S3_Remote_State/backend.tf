terraform {
  backend "s3" {
    bucket = "amg-terraform-user02-backend-tfstate"
    key = "amg/terraform.tfstate"
    region = "eu-west-3"

    dynamodb_table = "terraform-user02-amg-up-and-running-locks"
    encrypt = true
  }
}