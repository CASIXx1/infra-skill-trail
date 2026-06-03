variable "role_name" {
  description = "IAM role name for GitHub Actions backend deploy."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the role, in owner/repo format."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch pattern allowed to assume the role."
  type        = string
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs allowed for image push."
  type        = list(string)
}

variable "ecs_task_role_arn" {
  description = "ECS task role ARN allowed for iam:PassRole."
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN allowed for iam:PassRole."
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket containing Terraform state read by backend deploy workflows."
  type        = string
}

variable "terraform_state_key" {
  description = "S3 object key for the dev Terraform state read by backend deploy workflows."
  type        = string
}
