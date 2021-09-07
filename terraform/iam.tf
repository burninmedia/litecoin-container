data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.destination
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [""]
    }
  }

}

data "aws_iam_policy" "ec2" {
  provider = aws.destination
  name     = "AmazonEC2FullAccess"
}

resource "aws_iam_role" "prod_assume_role" {
  provider            = aws.destination
  name                = "${var.environment}-assume_role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [data.aws_iam_policy.ec2.arn]
}

resource "aws_iam_group" "group" {
  name = "${var.environment}-group"
  path = "/users/"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_iam_user" "user" {
  name = "${var.environment}-user"

  tags = {
    environment = "${var.environment}"
  }
}