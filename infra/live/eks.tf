module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Endpoint access : API EKS accessible (publique limitée à ton IP) + privé
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["102.0.13.160/32"]

  enable_irsa = true

  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  # Donne l’accès admin Kubernetes au user IAM ecs-deployer (EKS Access Entries)
  access_entries = {
    ecs_deployer = {
      principal_arn = "arn:aws:iam::481665100297:user/ecs-deployer"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 2
      max_size       = 4
      subnet_ids     = module.vpc.private_subnets
      capacity_type  = "ON_DEMAND"
      labels         = { role = "apps" }
      tags           = var.tags
    }
  }

  tags = var.tags
}
