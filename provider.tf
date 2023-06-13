terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.3"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      TERRAFORM_ECS_FARGATE_DEMO = "---"
    }
  }
}