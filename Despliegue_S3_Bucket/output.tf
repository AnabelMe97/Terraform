output "s3_bucket_arn" {
  value = aws_s3_bucket.storage.arn
  description = "The ARN of s3"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.storage.bucket_domain_name
  description = "The Domain name of the s3"
}