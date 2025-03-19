resource "aws_iot_topic_rule" "energy_rule" {
  name        = "energy_threshold_rule"
  description = "Forward IoT data to S3 and trigger Lambda when threshold is exceeded"
  sql         = "SELECT * FROM 'energy/consumption' WHERE consumption > 500"
  sql_version = "2016-03-23"
  enabled     = true

  # Action: Write to S3
  s3 {
    role_arn    = var.iot_role_arn
    bucket_name = var.iot_rule_action_s3_bucket
    key         = "iot-data/${aws_iot_topic_rule.energy_rule.name}/${timestamp()}.json"
    canned_acl  = "private"
  }

  # Action: Trigger Lambda
  lambda {
    function_arn = var.lambda_function_arn
  }
}
