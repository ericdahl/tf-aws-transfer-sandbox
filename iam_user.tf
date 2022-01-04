resource "aws_iam_role" "aws_transfer_user" {
  name = "tf-aws-transfer-sandbox"

  assume_role_policy = file("templates/iam/role/transfer.json")
}

resource "aws_iam_role_policy" "aws_transfer_user_policy" {

  role = aws_iam_role.aws_transfer_user.id

  policy = templatefile("templates/iam/policy/aws_transfer_user_s3.json", {
    bucket_arn : aws_s3_bucket.default.arn
  })
}

