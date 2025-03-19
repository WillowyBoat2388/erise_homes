data "aws_caller_identity" "current" {}

resource "aws_quicksight_data_source" "iot_data_source" {
  data_source_id = "s3_data_source"
  name           = "manifest in S3"

  parameters {
    s3 {
      manifest_file_location {
        bucket = var.s3_bucket_arn
        key    = aws_s3_object.example.key
      }
      role_arn = var.qwksight_role_arn
    }
  }

  type = "S3"
}