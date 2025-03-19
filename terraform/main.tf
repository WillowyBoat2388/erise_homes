# SNS Topic for Alerts
resource "aws_sns_topic" "energy_alerts" {
  name = "energy-alerts-topic"
}

# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role" {
  name = "energy_monitor_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
         "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach Basic Lambda Execution Role Policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom Policy to Allow Lambda to Publish to SNS
resource "aws_iam_policy" "lambda_invoke_sns_policy" {
  name        = "LambdaInvokeSNSPolicy"
  description = "Allow Lambda function to publish to SNS topic"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = ["sns:Publish"],
        Effect   = "Allow",
        Resource = aws_sns_topic.energy_alerts.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_invoke_sns_policy.arn
}

# Package Lambda Function Code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

# Lambda Function to Process Energy Data and Send Alerts
resource "aws_lambda_function" "energy_monitor" {
  function_name    = "energy_monitor_function"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.energy_alerts.arn
    }
  }
}

# IoT Topic Rule to Trigger the Lambda Function When Energy Consumption Exceeds a Threshold
resource "aws_iot_topic_rule" "energy_rule" {
  name        = "energy_threshold_rule"
  description = "Trigger Lambda when energy consumption exceeds threshold"
  sql         = "SELECT * FROM 'energy/consumption' WHERE consumption > 1000"  # Example threshold value
  sql_version = "2016-03-23"
  enabled     = true

  lambda {
    function_arn = aws_lambda_function.energy_monitor.arn
  }
}

# Allow AWS IoT to invoke the Lambda function
resource "aws_lambda_permission" "allow_iot" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.energy_monitor.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.energy_rule.arn
}


terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

module "iam" {
  source = "./modules/iam"
}

module "sns" {
  source = "./modules/sns"
}

module "lambda" {
  source                = "./modules/lambda"
  lambda_function_name  = var.lambda_function_name
  lambda_role_arn       = module.iam.lambda_role_arn
  s3_bucket             = module.s3.bucket_name
  sns_topic_arn         = module.sns.sns_topic_arn
}

module "iot" {
  source                     = "./modules/iot"
  iot_rule_action_s3_bucket  = module.s3.bucket_name
  lambda_function_arn        = module.lambda.lambda_function_arn
  iot_role_arn               = module.iam.iot_role_arn
}

module "secrets" {
  source                = "./modules/secrets"
  s3_bucket_name        = module.s3.bucket_name
  lambda_function_name  = var.lambda_function_name
}