provider "aws" {
    region = locals.region
}

terraform {
    backend "s3" {
        bucket = "terraform-state-<your-name>"
        key    = "terraform.tfstate"
        region = locals.region
    }

    required_version = ">= 1.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.16"
        }
        tls = {
            source  = "hashicorp/tls"
            version = "~> 4.0"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.11"
        }
        kubectl = {
            source  = "gavinbunney/kubectl"
            version = "~> 1.14"
        }
    }
}