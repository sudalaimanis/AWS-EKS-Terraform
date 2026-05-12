################################################################################
# VPC Module - Network Foundation
################################################################################
# Creates the VPC, subnets, internet gateway, NAT gateway, and route tables
# This is the foundation for all other infrastructure
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = "10.0.0.0/16"
  vpc_name    = "${var.project_name}-vpc"
  environment = var.environment
}

################################################################################
# Security Groups Module - Network Access Control
################################################################################
# Creates security groups for EKS cluster and worker nodes
# Manages ingress/egress rules for cluster communication
module "security_group" {
  source = "./modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment

  depends_on = [module.vpc]
}

################################################################################
# EKS Cluster Module - Kubernetes Control Plane & Worker Nodes
################################################################################
# Creates EKS cluster with IAM roles, cluster logging, and node groups
# Depends on VPC subnets and security groups
module "eks_cluster" {
  source = "./modules/eks"

  cluster_name       = "${var.project_name}-eks-cluster"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.eks_security_group_id]
  environment        = var.environment

  depends_on = [
    module.vpc,
    module.security_group
  ]
}

