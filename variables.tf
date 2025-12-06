variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cloudhomes"
}

variable "github_repository" {
  description = "GitHub repository URL for Amplify"
  type        = string
  default     = "https://github.com/yourusername/cloudhomes"
}

variable "cognito_domain" {
  description = "Custom domain for Cognito hosted UI"
  type        = string
  default     = "cloudhomes-auth"
}