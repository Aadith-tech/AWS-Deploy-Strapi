data "aws_s3_bucket" "strapi_media" {
  bucket = var.s3
}

resource "aws_s3_bucket_ownership_controls" "strapi_media" {
  bucket = data.aws_s3_bucket.strapi_media.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "strapi_media" {
  bucket = data.aws_s3_bucket.strapi_media.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "strapi_media" {
  bucket = data.aws_s3_bucket.strapi_media.id
  depends_on = [aws_s3_bucket_public_access_block.strapi_media]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.s3}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "strapi_media" {
  bucket = data.aws_s3_bucket.strapi_media.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

