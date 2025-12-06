variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "api_gateway_url" {
  description = "URL of the API Gateway"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository URL for Amplify"
  type        = string
}

variable "cognito_domain" {
  description = "Custom domain for Cognito hosted UI"
  type        = string
}

variable "user_pool_id" {
  description = "Cognito User Pool ID from backend module"
  type        = string
}

variable "user_pool_client_id" {
  description = "Cognito User Pool Client ID from backend module"
  type        = string
}