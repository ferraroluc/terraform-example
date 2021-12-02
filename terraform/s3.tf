resource "aws_s3_bucket" "prod-example-bucket" {
  bucket = "prod-example-bucket"
  acl    = "private"
}
resource "aws_s3_bucket_object" "prod-example-bucket-object" {
  bucket = aws_s3_bucket.prod-example-bucket.id
  key    = join("-", ["example", local.timestamp])
  acl    = "private"
  source = "${path.module}/../dist/example.zip"
  etag   = "${path.module}/../dist/example.zip"
}