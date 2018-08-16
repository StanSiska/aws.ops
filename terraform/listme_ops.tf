resource "aws_s3_bucket" "listmelogs" {
  bucket = "vvs.listme.logs"
  acl    = "log-delivery-write"

  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket" "listmeops" {
  depends_on = ["aws_s3_bucket.listmelogs"]
  bucket = "vvs.listme"
  acl    = "private"

  versioning {
    enabled = true
  }
  
  logging {
    target_bucket = "${aws_s3_bucket.listmelogs.id}"
    target_prefix = "listmelogs/"
  }
}
