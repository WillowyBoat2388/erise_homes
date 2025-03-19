resource "aws_secretsmanager_secret" "s3_secret" {
  name = "${var.s3_bucket_name}-secret"
}

resource "aws_secretsmanager_secret_version" "s3_secret_version" {
  secret_id     = aws_secretsmanager_secret.s3_secret.id
  secret_string = jsonencode({ encryption_key = "example-s3-encryption-key" })
}

resource "aws_secretsmanager_secret" "lambda_secret" {
  name = "${var.lambda_function_name}-secret"
}

resource "aws_secretsmanager_secret_version" "lambda_secret_version" {
  secret_id     = aws_secretsmanager_secret.lambda_secret.id
  secret_string = jsonencode({ api_key = "example-lambda-api-key" })
}

output "s3_secret_arn" {
  value = aws_secretsmanager_secret.s3_secret.arn
}

output "lambda_secret_arn" {
  value = aws_secretsmanager_secret.lambda_secret.arn
}
