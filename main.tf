terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region        = "eu-north-1"
}

#Creating ECR

resource "aws_ecr_repository" "app_repo" {
  name                 = "app_repo"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

#Adding open-source module to create CodeBuild instance

module "build" {
  source              = "cloudposse/codebuild/aws"
  version             = "4.67.0"
  name                = "app_build"

  build_image         = "aws/codebuild/standard:7.0"
  build_compute_type  = "BUILD_GENERAL1_SMALL"
  build_timeout       = 60

  privileged_mode     = true
  aws_region          = "eu-north-1"
  aws_account_id      = "552948186969"
  image_repo_name     = "app_repo"
  image_tag           = "latest"
}