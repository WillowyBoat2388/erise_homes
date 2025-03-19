output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}

output "quicksight_data_source_id" {
  value = module.quicksight.quicksight_data_source_id
}

output "iot_endpoint" {
  description = "AWS IoT Core endpoint for device connection"
  value       = data.aws_iot_endpoint.current.endpoint_address
}

output "data_bucket_name" {
  description = "Name of the S3 bucket for data storage"
  value       =module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for data storage"
  value       = module.s3.bucket_arn
}

# output "firehose_delivery_stream_name" {
#   description = "Name of the Kinesis Firehose delivery stream"
#   value       = aws_kinesis_firehose_delivery_stream.erise_data_stream.name
# }

# output "kms_key_id" {
#   description = "ID of the KMS key for data encryption"
#   value       = aws_kms_key.erise_data_key.key_id
# }

# output "kms_key_alias" {
#   description = "Alias of the KMS key for data encryption"
#   value       = aws_kms_alias.erise_data_key_alias.name
# }
# # This data source gets the IoT endpoint
# data "aws_iot_endpoint" "current" {
#   endpoint_type = "iot:Data-ATS"
# }