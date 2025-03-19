data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "iot_monitor_lambda" {
  function_name = var.lambda_function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = var.lambda_role_arn
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
      BUCKET_NAME   = var.s3_bucket
    }
  }
}

output "lambda_function_name" {
  value = aws_lambda_function.iot_monitor_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.iot_monitor_lambda.arn
}
