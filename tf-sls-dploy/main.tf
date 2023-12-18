
resource "aws_s3_bucket" "example" {
  bucket = "serverless-841079562861-ap-southeast-2"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
