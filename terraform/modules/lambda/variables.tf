variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name for storing data"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alert notifications"
  type        = string
}
