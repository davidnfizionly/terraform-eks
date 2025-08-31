variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile (optionnel)"
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Nom globalement unique pour le bucket S3 du state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le state lock"
  type        = string
  default     = "tfstate-locks"
}

variable "tags" {
  description = "Tags communs"
  type        = map(string)
  default     = {
    Project   = "Terraform-EKS-Demo"
    ManagedBy = "Terraform"
    Env       = "dev"
  }
}
