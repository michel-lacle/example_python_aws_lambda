variable "lambda_file" {
  type = string
  default = "lambda.py"
}

variable "lambda_zip_file" {
  type = string
  default = "lambda.zip"
}

data "archive_file" "notification_lambda" {
  type = "zip"

  source_file = "${path.module}/${var.lambda_file}"
  output_path = "${path.module}/${var.lambda_zip_file}"
}

resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Application = var.application_tag
    Contact = var.contact_tag
    ManagedBy = var.managedby_tag
  }
}

resource "aws_lambda_function" "this" {
  filename = "${path.module}/${var.lambda_zip_file}"
  function_name = var.name
  role = aws_iam_role.this.arn
  handler = "lambda.my_test_function"

  source_code_hash = filebase64sha256("${path.module}/${var.lambda_zip_file}")

  runtime = "python3.7"

  timeout = 300

  environment {
    variables = {
      DEBUG = "true"
    }
  }

  tags = {
    Application = var.application_tag
    Contact = var.contact_tag
    ManagedBy = var.managedby_tag
  }

  depends_on = [
    data.archive_file.notification_lambda]
}

resource "aws_lambda_permission" "this" {

  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal = "s3.amazonaws.com"

  source_arn = data.aws_s3_bucket.this.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = data.aws_s3_bucket.this.bucket

  lambda_function {

    lambda_function_arn = aws_lambda_function.this.arn

    events = [
      "s3:ObjectCreated:*"]

    filter_prefix = "foo/foo/"
    filter_suffix = ".zip"
  }

  depends_on = [
    aws_lambda_permission.this]
}
