# DynamoDB Tables
resource "aws_dynamodb_table" "properties" {
  name         = "${var.project_name}-properties-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "propertyId"
  
  attribute {
    name = "propertyId"
    type = "S"
  }
  
  attribute {
    name = "userId"
    type = "S"
  }
  
  # GSI for querying by user
  global_secondary_index {
    name            = "userId-index"
    hash_key        = "userId"
    projection_type = "ALL"
  }
  
  tags = {
    Name        = "${var.project_name}-properties"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "users" {
  name         = "${var.project_name}-users-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  
  attribute {
    name = "userId"
    type = "S"
  }
  
  tags = {
    Name        = "${var.project_name}-users"
    Environment = var.environment
  }
}

# S3 Bucket for property images (Private)
resource "aws_s3_bucket" "property_images" {
  bucket = "${var.project_name}-images-${var.environment}-${var.suffix}"
}

resource "aws_s3_bucket_acl" "property_images" {
  bucket = aws_s3_bucket.property_images.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "property_images" {
  bucket = aws_s3_bucket.property_images.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "property_images" {
  bucket = aws_s3_bucket.property_images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name = "${var.project_name}-users-${var.environment}"
  
  # Email-only authentication
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]
  
  # Password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = true
    require_symbols   = false
    require_uppercase = false
  }
  
  # Schema
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }
  
  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  
  # Verification message
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your CloudHomes Verification Code"
    email_message        = "Your verification code is {####}"
  }
  
  tags = {
    Name        = "${var.project_name}-user-pool"
    Environment = var.environment
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "web" {
  name = "${var.project_name}-web-client-${var.environment}"
  
  user_pool_id = aws_cognito_user_pool.main.id
  
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
  
  supported_identity_providers = ["COGNITO"]
  
  callback_urls = [
    "http://localhost:3000",
    "https://*.amazonaws.com" # Amplify domains
  ]
  
  logout_urls = [
    "http://localhost:3000",
    "https://*.amazonaws.com"
  ]
  
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows  = ["code", "implicit"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile"]
  
  prevent_user_existence_errors = "ENABLED"
}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.project_name}-auth-${var.environment}"
  user_pool_id = aws_cognito_user_pool.main.id
}

# API Gateway
resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-api-${var.environment}"
  protocol_type = "HTTP"
  description   = "CloudHomes Real Estate API"
  
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
    max_age       = 300
  }
  
  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true
  
  tags = {
    Name        = "${var.project_name}-api-stage"
    Environment = var.environment
  }
}
