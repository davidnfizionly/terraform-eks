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

variable "project_name" {
  description = "Nom logique du projet"
  type        = string
  default     = "terraform-eks-demo"
}

variable "environment" {
  description = "Environnement (dev/stage/prod)"
  type        = string
  default     = "dev"
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

# --- VPC / Réseau ---

variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Nombre d'AZ"
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Activer un NAT Gateway (sortie Internet pour subnets privés)"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Un seul NAT (low-cost)"
  type        = bool
  default     = true
}
