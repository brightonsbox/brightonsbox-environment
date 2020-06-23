terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "brightonsbox"

    workspaces {
      name = "brightonsbox-environment"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "template" {
}

resource "aws_iam_user" "circleci" {
  name = var.user
  path = "/system/"
}

resource "aws_iam_access_key" "circleci" {
  user = aws_iam_user.circleci.name
}

data "template_file" "circleci_policy" {
  template = file("circleci_s3_access.tpl.json")
  vars = {
    s3_bucket_arn = aws_s3_bucket.brightonsbox.arn
  }
}

resource "local_file" "circle_credentials" {
  filename = "tmp/circleci_credentials"
  content  = "${aws_iam_access_key.circleci.id}\n${aws_iam_access_key.circleci.secret}"
}

resource "aws_iam_user_policy" "circleci" {
  name   = "AllowCircleCI"
  user   = aws_iam_user.circleci.name
  policy = data.template_file.circleci_policy.rendered
}

resource "aws_s3_bucket" "brightonsbox" {
  tags = {
    Name = "brightonsbox website bucket"
  }

  bucket = "${var.bucket}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true
}

output "Endpoint" {
  value = aws_s3_bucket.brightonsbox.website_endpoint
}
