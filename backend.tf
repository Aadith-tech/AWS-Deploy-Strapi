terraform {
  backend "s3" {
    bucket = "aadithnewbucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    profile = "iamadmin-general"

  }
}