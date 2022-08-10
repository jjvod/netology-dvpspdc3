terraform {
  backend "s3" {
    bucket         = "jjvod-bucket1"
    key            = "state/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}