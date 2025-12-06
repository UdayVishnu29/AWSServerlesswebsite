# AWS Amplify App (Deployed in Mumbai for better latency in India)
resource "aws_amplify_app" "main" {
  provider = aws.mumbai
  
  name       = "${var.project_name}-frontend-${var.environment}"
  repository = var.github_repository
  platform   = "WEB"
  
  # Build settings - will be overridden by amplify.yml in repo
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
  
  # Environment variables for Next.js
  environment_variables = {
    NEXT_PUBLIC_API_URL = var.api_gateway_url
    NEXT_PUBLIC_REGION  = "ap-south-1"
    NEXT_PUBLIC_USER_POOL_ID = var.user_pool_id
    NEXT_PUBLIC_USER_POOL_CLIENT_ID = var.user_pool_client_id
  }
  
  # Custom rules for SPA routing
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
  
  custom_rule {
    source = "/property/<*>"
    status = "200"
    target = "/property/[id]/index.html"
  }
  
  tags = {
    Name        = "${var.project_name}-frontend"
    Environment = var.environment
  }
}

# Main branch
resource "aws_amplify_branch" "main" {
  provider = aws.mumbai
  
  app_id      = aws_amplify_app.main.id
  branch_name = "main"
  
  framework = "Next.js - SSR"
  stage     = var.environment == "prod" ? "PRODUCTION" : "DEVELOPMENT"
  
  enable_auto_build = true
  enable_performance_mode = true
}

# Amplify Domain association
resource "aws_amplify_domain_association" "main" {
  provider = aws.mumbai
  count    = var.environment == "prod" ? 1 : 0
  
  app_id      = aws_amplify_app.main.id
  domain_name = "cloudhomes-realestate.com" # Your custom domain
  
  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
  
  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }
}