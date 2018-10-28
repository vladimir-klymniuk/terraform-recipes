

resource "aws_s3_bucket" "vk-test-demo-bucket" {
  bucket = "vk-test-demo"
  acl = "public-read"
  policy = "${file("bucket_policy.json")}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

}
