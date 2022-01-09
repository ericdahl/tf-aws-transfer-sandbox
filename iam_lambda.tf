resource "aws_iam_role" "aws_transfer_lambda" {
  name = "tf-aws-transfer-sandbox-lambda"

  assume_role_policy = file("templates/iam/role/lambda.json")
}

resource "aws_iam_role_policy" "aws_transfer_lambda_policy" {
  role = aws_iam_role.aws_transfer_lambda.id

  policy = templatefile("templates/iam/policy/aws_lambda_logs.json", {
    bucket_arn : aws_s3_bucket.default.arn
  })
}

