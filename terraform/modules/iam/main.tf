resource "aws_iam_role" "lambda_role" {
  name = "iot_monitor_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect    = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "iot_role" {
  name = "iot_monitor_iot_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "iot.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "iot_policy" {
  name   = "iot_monitor_iot_policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action   = ["s3:PutObject", "s3:PutObjectAcl"],
      Effect   = "Allow",
      Resource = "${var.s3_bucket_arn}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "iot_policy_attachment" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.iot_policy.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "iot_role_arn" {
  value = aws_iam_role.iot_role.arn
}
