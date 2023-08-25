data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "dynamodb_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeContributorInsights",
      "dynamodb:RestoreTableToPointInTime",
      "dynamodb:UpdateGlobalTable",
      "dynamodb:UpdateTableReplicaAutoScaling",
      "dynamodb:DescribeTable",
      "dynamodb:PartiQLInsert",
      "dynamodb:GetItem",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeExport",
      "dynamodb:ListImports",
      "dynamodb:EnableKinesisStreamingDestination",
      "dynamodb:BatchGetItem",
      "dynamodb:DisableKinesisStreamingDestination",
      "dynamodb:UpdateTimeToLive",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:PartiQLUpdate",
      "dynamodb:Scan",
      "dynamodb:StartAwsBackupJob",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateGlobalTableSettings",
      "dynamodb:CreateTable",
      "dynamodb:RestoreTableFromAwsBackup",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ExportTableToPointInTime",
      "dynamodb:DescribeEndpoints",
      "dynamodb:DescribeBackup",
      "dynamodb:UpdateTable",
      "dynamodb:GetRecords",
      "dynamodb:DescribeTableReplicaAutoScaling",
      "dynamodb:DescribeImport",
      "dynamodb:ListTables",
      "dynamodb:PurchaseReservedCapacityOfferings",
      "dynamodb:CreateTableReplica",
      "dynamodb:ListTagsOfResource",
      "dynamodb:UpdateContributorInsights",
      "dynamodb:CreateBackup",
      "dynamodb:UpdateContinuousBackups",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:PartiQLSelect",
      "dynamodb:UpdateGlobalTableVersion",
      "dynamodb:CreateGlobalTable",
      "dynamodb:DescribeKinesisStreamingDestination",
      "dynamodb:DescribeLimits",
      "dynamodb:ImportTable",
      "dynamodb:ListExports",
      "dynamodb:ConditionCheckItem",
      "dynamodb:ListBackups",
      "dynamodb:Query",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListStreams",
      "dynamodb:ListContributorInsights",
      "dynamodb:DescribeGlobalTableSettings",
      "dynamodb:ListGlobalTables",
      "dynamodb:DescribeGlobalTable",
      "dynamodb:RestoreTableFromBackup",
    ]
    resources = ["*"]
  }
}
