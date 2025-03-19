data "aws_caller_identity" "current" {}

resource "aws_quicksight_data_source" "iot_data_source" {
  data_source_id = "s3_data_source"
  name           = "manifest in S3"

  parameters {
    s3 {
      manifest_file_location {
        bucket = var.s3_bucket_arn
        key    = var.s3_bucket
      }
    }
  }
  type = "S3"
}

output "quicksight_data_source_id" {
  value = aws_quicksight_data_source.iot_data_source.id
}