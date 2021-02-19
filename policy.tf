data "aws_iam_policy_document" "this" {

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::yourbuckethere",
      "arn:aws:s3:::yourbuckethere/*"
    ]

    sid = "s3access"
  }
}

resource "aws_iam_role_policy" "this" {
  policy = data.aws_iam_policy_document.this.json
  role = aws_iam_role.this.id
}