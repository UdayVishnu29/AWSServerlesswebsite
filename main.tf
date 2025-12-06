
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "suffix" {
  byte_length = 4
}

module "networking" {
  source = "./modules/networking"
  
  project_name = var.project_name
  environment  = var.environment
  account_id   = data.aws_caller_identity.current.account_id
  region       = data.aws_region.current.name
}

module "backend" {
  source = "./modules/backend"
  
  project_name    = var.project_name
  environment     = var.environment
  suffix          = random_id.suffix.hex
  lambda_role_arn = module.networking.lambda_role_arn
}

module "frontend" {
  source = "./modules/frontend"
  
  providers = {
    aws.mumbai = aws.mumbai
  }
  
  project_name      = var.project_name
  environment       = var.environment
  api_gateway_url   = module.backend.api_gateway_url
  github_repository = var.github_repository
  cognito_domain    = var.cognito_domain
  user_pool_id      = module.backend.cognito_user_pool_id
  user_pool_client_id = module.backend.cognito_user_pool_client_id
}
