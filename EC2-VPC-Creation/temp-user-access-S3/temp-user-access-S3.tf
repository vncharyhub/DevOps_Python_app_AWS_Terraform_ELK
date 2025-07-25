provider "aws" {
  region = "us-east-1"
}

# 1. Temporary IAM User
resource "aws_iam_user" "temp_user" {
  name = "temp-user"
}

# 2. Inline Policy to Give Full Access to Specific S3 Bucket
resource "aws_iam_user_policy" "temp_user_s3_fullaccess" {
  name = "temp-user-s3-fullaccess"
  user = aws_iam_user.temp_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = [
          "arn:aws:s3:::EBS-Snapshots-backup-files",
          "arn:aws:s3:::EBS-Snapshots-backup-files/*"
        ]
      }
    ]
  })
}

# 3. Optional: Create access keys for the user (use these for programmatic access)
resource "aws_iam_access_key" "temp_user_key" {
  user = aws_iam_user.temp_user.name
}

# 4. Outputs
output "access_key_id" {
  value = aws_iam_access_key.temp_user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.temp_user_key.secret
  sensitive = true
}
