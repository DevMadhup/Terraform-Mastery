provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "mybuck1234213"

}

resource "aws_s3_bucket_public_access_block" "allow" {
  bucket            = aws_s3_bucket.bucket.id
  block_public_acls = false
}

output "myoutput" {
  value = aws_s3_bucket.bucket.bucket
}
