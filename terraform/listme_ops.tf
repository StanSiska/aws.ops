resource "aws_kms_key" "listmeops" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  alias                   = "ListMe OPS bucket key"
}

resource "aws_kms_alias" "listmeops" {
  name          = "alias/listme/ops"
  target_key_id = "${aws_kms_key.listmeops.key_id}"
}

resource "aws_kms_key" "listmelogs" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "listmelogs" {
  name          = "alias/listme/logs"
  target_key_id = "${aws_kms_key.listmelogs.key_id}"
}

resource "aws_kms_key" "secretmanagement" {
  description             = "This key is used to encrypt secrets"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "secretmanagement" {
  name          = "alias/listme/secrets"
  target_key_id = "${aws_kms_key.secretmanagement.key_id}"
}

resource "aws_s3_bucket" "listmelogs" {
  depends_on = ["aws_kms_key.listmelogs"]
  bucket = "vvc.listme.logs"
  acl    = "log-delivery-write"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.listmelogs.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "listmeops" {
  depends_on = ["aws_s3_bucket.listmelogs", "aws_kms_key.listmeops"]
  bucket = "vvc.listme.ops"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.listmeops.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  
  acl    = "private"

  versioning {
    enabled = true
  }
  
  logging {
    target_bucket = "${aws_s3_bucket.listmelogs.id}"
    target_prefix = "listmelogs/"
  }
}
