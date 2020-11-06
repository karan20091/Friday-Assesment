
resource "aws_s3_bucket" "my_s3_bucket" {

  count  = length(var.bucket_names)
  bucket = "my-s3-bucket-${var.bucket_names[count.index]}"
  acl    = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "reports/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_policy" "my_s3_policy" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.my_s3_bucket[count.index].id
  policy = data.aws_iam_policy_document.my_policy[count.index].json
}



data "aws_iam_policy_document" "my_policy" {
  count = length(var.bucket_names)
  statement {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [

    "${aws_s3_bucket.my_s3_bucket[count.index].arn}/*"
    ]
  }
}