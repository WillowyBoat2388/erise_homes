variable "iot_rule_action_s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket identification ARN"
  type        = string
}

variable "qwksight_role_arn" {
  description = "IAM role ARN that QuickSight will assume"
  type        = string
}