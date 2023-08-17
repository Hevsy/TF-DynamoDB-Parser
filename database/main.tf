
resource "random_pet" "this" {
  length = 2
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "3.3.0"

  name                        = "${var.app}-${var.stage}"
  hash_key                    = "siteId"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "siteId"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    App         = "${var.app}"
    Environment = "${var.stage}"
  }
}


# resource "aws_ssm_parameter" "ddbp-db" {
#   name  = "foo"
#   type  = "String"
#   value = "bar"
# }