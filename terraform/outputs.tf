output "sns_topic_arn" {
  value = aws_sns_topic.energy_alerts.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.energy_monitor.function_name
}


output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}

output "quicksight_data_source_id" {
  value = module.quicksight.quicksight_data_source_id
}
