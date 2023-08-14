# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source = "github.com/Hevsy/terraform-modules//terraform-aws-tfstate-backend?ref=v1.0.0"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "1.0.0"
  namespace  = "ppv"
  stage      = "dev"
  name       = "terraform"
  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}

# Your Terraform configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.app}-vpn"
  cidr = "10.123.0.0/24"

  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = ["10.123.101.0/24"]
  intra_subnets  = ["10.123.51.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    app         = "${var.app}"
  }
}

resource "aws_key_pair" "ddbp_auth" {
  key_name   = "ire1"
  public_key = file("~/.ssh/ire1.pub")
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    app         = "${var.app}"
  }
}