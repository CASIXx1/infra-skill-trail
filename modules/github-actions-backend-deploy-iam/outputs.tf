output "role_arn" {
  description = "IAM role ARN for GitHub Actions backend deploy."
  value       = aws_iam_role.this.arn
}
