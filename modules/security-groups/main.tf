# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name_prefix = "eks-cluster-"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "eks-cluster-sg"
    Environment = var.environment
  }
}

# Allow inbound traffic on port 443 (HTTPS/Kubernetes API)
resource "aws_vpc_security_group_ingress_rule" "eks_cluster_https" {
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "eks-cluster-https"
  }
}

# Allow all outbound traffic IPv4
resource "aws_vpc_security_group_egress_rule" "eks_cluster_outbound_ipv4" {
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "eks-cluster-outbound-ipv4"
  }
}

# Allow all outbound traffic IPv6
resource "aws_vpc_security_group_egress_rule" "eks_cluster_outbound_ipv6" {
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"

  tags = {
    Name = "eks-cluster-outbound-ipv6"
  }
}
