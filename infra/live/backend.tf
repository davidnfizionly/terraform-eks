terraform {
  backend "s3" {
    bucket  = "davidnfizi-tfstate-eks-prod"
    key     = "eks/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    use_lockfile = true   # remplace l'ancien dynamodb_table
  }
}
