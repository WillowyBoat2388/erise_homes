variable "s3_bucket_name" {
  description = "S3 bucket name for IoT rule action"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to trigger"
  type        = string
}

variable "iot_role_arn" {
  description = "IAM role ARN that IoT will assume"
  type        = string
}
