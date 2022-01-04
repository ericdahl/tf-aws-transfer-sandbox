provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Provisioner = "Terraform"
      Name        = "tf-aws-transfer-sandbox"
    }
  }
}



resource "aws_s3_bucket" "default" {
  bucket        = "tf-aws-transfer-sandbox"
  force_destroy = true
}

resource "aws_s3_bucket_object" "default_hello" {
  bucket = aws_s3_bucket.default.bucket
  key    = "hello.txt"

  content = "hello world"
}

resource "aws_eip" "transfer_us_east_1a" {
  vpc = true
}

resource "aws_eip" "transfer_us_east_1b" {
  vpc = true
}

resource "aws_security_group" "aws_transfer" {
  vpc_id = aws_vpc.vpc.id

  name = "tf-aws-transfer-sandbox"
}

resource "aws_security_group_rule" "aws_transfer_ingress_22" {
  security_group_id = aws_security_group.aws_transfer.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = var.ingress_cidrs

}

resource "aws_transfer_server" "default" {

  protocols = ["SFTP"]

  endpoint_type = "VPC"

  endpoint_details {
    vpc_id = aws_vpc.vpc.id

    subnet_ids = [
      aws_subnet.public_10_1_0_0.id,
      aws_subnet.public_10_2_0_0.id
    ]

    security_group_ids = [
      aws_security_group.aws_transfer.id
    ]

    address_allocation_ids = [
      aws_eip.transfer_us_east_1a.allocation_id,
      aws_eip.transfer_us_east_1b.allocation_id,
    ]
  }

  logging_role = aws_iam_role.aws_transfer_cloudwatch_logs.arn

}

resource "aws_transfer_user" "user" {
  server_id = aws_transfer_server.default.id
  role      = aws_iam_role.aws_transfer_user.arn
  user_name = "test-user"

  home_directory = "/${aws_s3_bucket.default.bucket}"

}


resource "aws_transfer_ssh_key" "user" {
  user_name = aws_transfer_user.user.user_name
  server_id = aws_transfer_server.default.id
  body      = var.user_public_ssh_key
}

resource "aws_cloudwatch_log_group" "aws_transfer" {
  name = "/aws/transfer/${aws_transfer_server.default.id}"
}
