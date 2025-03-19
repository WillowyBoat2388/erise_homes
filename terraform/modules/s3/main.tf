resource "aws_s3_bucket" "iot_data_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.iot_data_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.iot_data_bucket.id
}
