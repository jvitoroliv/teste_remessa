# EKS cluster data sources and module configuration

# Retrieve cluster endpoint and CA for the Kubernetes provider
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

# EKS cluster using the official terraform-aws-modules/eks/aws module
# Upgraded from deprecated worker_groups to eks_managed_node_groups
module "eks" {
  depends_on = [aws_vpc.tf_vpc]

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = aws_vpc.tf_vpc.id
  subnet_ids = [aws_subnet.tf_subnet.id, aws_subnet.tf_subnet2.id]

  # Allow public access to the cluster API endpoint
  cluster_endpoint_public_access = true

  # EKS Managed Node Group (replaces deprecated worker_groups)
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.large"]

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }

  # Grant the cluster creator admin permissions
  enable_cluster_creator_admin_permissions = true
}
