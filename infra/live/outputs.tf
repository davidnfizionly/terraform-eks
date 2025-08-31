output "vpc_id"         { value = module.vpc.vpc_id }
output "public_subnets" { value = module.vpc.public_subnets }
output "private_subnets"{ value = module.vpc.private_subnets }
output "igw_id"         { value = module.vpc.igw_id }
output "nat_public_ips" { value = module.vpc.nat_public_ips }
output "cluster_name"              { value = module.eks.cluster_name }
output "cluster_endpoint"          { value = module.eks.cluster_endpoint }
output "cluster_oidc_provider_arn" { value = module.eks.oidc_provider_arn }
