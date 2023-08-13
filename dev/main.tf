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
    source = "terraform-aws-modules/vpc/aws"

    name = "ddbp-vpn"
    cidr = "10.123.0.0/24"

    azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = false
    enable_vpn_gateway = false

    tags = {
    Terraform = "true"
    Environment = "dev"
    }
}