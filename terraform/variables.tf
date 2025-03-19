variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "erise"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for IoT data storage"
  type        = string
  default     = "iot-monitoring-data-bucket"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "iot-monitoring-lambda"
}

variable "apartment_ids" {
  description = "List of apartment IDs for IoT device registration"
  type        = list(string)
  default     = ["001", "002", "003", "004", "005"]
}

variable "alert_email_endpoints" {
  description = "Email addresses to receive SNS alerts"
  type        = list(string)
  default     = ["admin@erisehomes.com", "support@erisehomes.com"]
}

variable "domain_name" {
  description = "Domain name for API and web services"
  type        = string
  default     = "erisehomes.com"
}

variable "retention_period_days" {
  description = "Data retention period in days"
  type        = number
  default     = 1825  # 5 years
}

variable "alarm_thresholds" {
  description = "Thresholds for various alarm types"
  type        = map(number)
  default     = {
    temperature_high = 30.0
    temperature_low  = 5.0
    humidity_high    = 80.0
    humidity_low     = 20.0
  }
}

variable "data_sampling_rate_seconds" {
  description = "Rate at which sensor data is sampled in seconds"
  type        = number
  default     = 60
}

variable "quicksight_users" {
  description = "List of QuickSight users who need access to the dashboard"
  type        = list(string)
  default     = ["analyst@erisehomes.com", "management@erisehomes.com"]
}

variable "enable_data_analytics" {
  description = "Toggle to enable or disable data analytics components"
  type        = bool
  default     = true
}

variable "enable_notifications" {
  description = "Toggle to enable or disable notification components"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Toggle to enable or disable data backups"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}