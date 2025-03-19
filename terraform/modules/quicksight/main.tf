data "aws_caller_identity" "current" {}

resource "aws_quicksight_data_source" "iot_data_source" {
  data_source_id = "iot-s3-data-source"
  name           = "IoT S3 Data Source"
  type           = "S3"
  aws_account_id = data.aws_caller_identity.current.account_id

  data_source_parameters {
    s3_parameters {
      manifest_file_location {
        bucket = var.s3_bucket_arn
        key    = "path/to/manifest.json"
      }
    }
  }

  permissions {
    principal = data.aws_caller_identity.current.arn
    actions   = [
      "quicksight:DescribeDataSource",
      "quicksight:DescribeDataSourcePermissions",
      "quicksight:PassDataSource"
    ]
  }
}

output "quicksight_data_source_id" {
  value = aws_quicksight_data_source.iot_data_source.data_source_id
}
