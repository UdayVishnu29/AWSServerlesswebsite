output "amplify_app_id" {
  description = "Amplify App ID"
  value       = aws_amplify_app.main.id
}

output "amplify_app_url" {
  description = "Amplify App URL"
  value       = "https://main.${aws_amplify_app.main.default_domain}"
}

output "amplify_branch_name" {
  description = "Amplify branch name"
  value       = aws_amplify_branch.main.branch_name
}