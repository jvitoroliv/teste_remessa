//varrendo o modulo para buscar o id do cluster
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

//varrendo o modulo para buscar o id do cluster
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

//criando cluster eks
module "eks" {
  depends_on      = [aws_vpc.tf_vpc]
  source          = "terraform-aws-modules/eks/aws"
  cluster_version = "1.21"
  cluster_name    = var.cluster_name
  vpc_id          = aws_vpc.tf_vpc.id
  subnets         = [aws_subnet.tf_subnet.id, aws_subnet.tf_subnet2.id]

  worker_groups = [
    {
      instance_type = "t2.large"
      asg_max_size  = 1
    }
  ]
}