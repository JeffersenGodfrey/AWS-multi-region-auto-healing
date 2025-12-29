terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# PRIMARY REGION
provider "aws" {
  region = var.primary_region
}

# SECONDARY REGION
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}


