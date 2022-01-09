resource "aws_iam_role" "aws_transfer_cloudwatch_logs" {
  name               = "tf-aws-transfer-sandbox-server"
  assume_role_policy = file("templates/iam/role/transfer.json")
}

resource "aws_iam_role_policy" "aws_transfer_cloudwatch_logs_policy" {
  role   = aws_iam_role.aws_transfer_cloudwatch_logs.id
  policy = file("templates/iam/policy/aws_transfer_cloudwatch_server.json")
}

