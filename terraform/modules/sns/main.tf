resource "aws_sns_topic" "alerts" {
  name = "iot_energy_alerts"
  kms_master_key_id = "alias/aws/sns"
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
