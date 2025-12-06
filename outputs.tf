output "frontend_url" {
  description = "URL of the deployed frontend application"
  value       = module.frontend.amplify_app_url
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = module.backend.api_gateway_url
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.backend.cognito_user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.backend.cognito_user_pool_client_id
}

output "dynamodb_table_names" {
  description = "Names of DynamoDB tables"
  value       = module.backend.dynamodb_table_names
}

output "s3_bucket_name" {
  description = "Name of S3 bucket for images"
  value       = module.backend.s3_bucket_name
}