resource "aws_iam_role" "strapi_role" {
  name = "strapi-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "strapi_s3_policy" {
  name = "strapi-s3-access"
  role = aws_iam_role.strapi_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::aadithnewbucket",
          "arn:aws:s3:::aadithnewbucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "strapi_profile" {
  name = "strapi-instance-profile"
  role = aws_iam_role.strapi_role.name
}