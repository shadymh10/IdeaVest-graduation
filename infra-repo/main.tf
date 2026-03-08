# ============================================
# Root Module - Clean Architecture
# ============================================

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "eks" {
  source = "./modules/eks"

  project_name         = var.project_name
  environment          = var.environment
  eks_cluster_version  = var.eks_cluster_version
  subnet_ids           = module.vpc.private_subnet_ids
  cluster_sg_id        = module.security_groups.cluster_sg_id
  node_sg_id           = module.security_groups.node_sg_id
  cluster_role_arn     = module.iam.cluster_role_arn
  node_role_arn        = module.iam.node_role_arn
  node_instance_type   = var.node_instance_type
  node_desired_count   = var.node_desired_count
  node_min_count       = var.node_min_count
  node_max_count       = var.node_max_count
}
