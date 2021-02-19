data "aws_iam_policy_document" "this" {

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]

    sid = "s3access"
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:*"
    ]

    resources = [
      "*"
    ]

    sid = "cloudwatch"
  }
}

resource "aws_iam_role_policy" "this" {
  policy = data.aws_iam_policy_document.this.json
  role = aws_iam_role.this.id
}