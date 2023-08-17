terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "ppv-dev-terraform-state"
    key            = "ddb/terraform.tfstate"
    dynamodb_table = "ppv-dev-terraform-state-lock"
    profile        = "ppv-tf"
    role_arn       = ""
    encrypt        = "true"
  }
}
