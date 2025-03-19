resource "aws_sns_topic" "alerts" {
  name = "iot_energy_alerts"
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
