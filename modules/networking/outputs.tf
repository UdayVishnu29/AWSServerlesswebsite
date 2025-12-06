output "lambda_role_arn" {
  description = "IAM Role ARN for Lambda functions"
  value       = aws_iam_role.lambda_exec.arn
}

output "lambda_role_name" {
  description = "IAM Role name for Lambda functions"
  value       = aws_iam_role.lambda_exec.name
}