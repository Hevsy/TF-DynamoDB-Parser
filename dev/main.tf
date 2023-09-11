# Your Terraform configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.app}-${var.stage}-vpn"
  cidr = "10.123.0.0/24"

  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = ["10.123.0.0/25"]
  intra_subnets  = ["10.123.0.128/25"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "${var.stage}"
    App         = "${var.app}"
  }
}

resource "aws_key_pair" "ddbp_ire1" {
  key_name   = "ddp_ire1-${var.stage}"
  public_key = file("~/.ssh/ddp_ire1.pub")
}

resource "aws_security_group" "public_ssh_sg" {
  name        = "public_ssh_sg"
  description = "public SSH security group"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "ddbp_policy" {
  name   = "ddbp_policy"
  policy = data.aws_iam_policy_document.dynamodb_policy.json
}


# resource "aws_iam_role" "ddbp_role" {
#   name = "dynamodb_limited_access_role"

#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
#   policy_arn         = aws_iam_policy.dynamodb_policy.policy_arn

#   tags = {
#     Terraform   = "true"
#     Environment = "${var.stage}"
#     app         = "${var.app}"
#   }
# }

# resource "aws_iam_instance_profile" "ddbp_profile" {
#   name = "${var.app}-${var.stage}-profile"
#   role = aws_iam_role.ddbp_role.name
# }

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "${var.app}-${var.stage}-node"

  ami                         = data.aws_ami.server_ami.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ddbp_ire1.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.public_ssh_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  # iam_instance_profile        = aws_iam_instance_profile.ddbp_profile.name
  create_iam_instance_profile = true
  iam_role_policies           = { LimitedDynamoDBaccess = aws_iam_policy.ddbp_policy.arn }
  iam_role_name               = "ddbp_role"
  ignore_ami_changes          = true

  tags = {
    Terraform   = "true"
    Environment = "${var.stage}"
    App         = "${var.app}"
  }
}

resource "aws_ec2_instance_state" "instance_state" {
  instance_id = module.ec2_instance.id
  state       = var.instance_stopped ? "stopped" : "running"
}