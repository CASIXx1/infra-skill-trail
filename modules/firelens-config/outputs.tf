output "bucket_arn" {
  description = "S3 bucket ARN for FireLens config."
  value       = aws_s3_bucket.this.arn
}

output "config_s3_arn" {
  description = "S3 object ARN for the FireLens Fluent Bit config."
  value       = aws_s3_object.config.arn
}
