# local is used to define a local variable for the Cluster name
# It concatenates the string "eks-" with the random suffix generated above
locals {
  cluster_name = "eks-${random_string.suffix.result}"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnets
  enable_irsa     = true

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }
  tags = {
    cluster     = "terraform-eks-demo"
    environment = "demo"
  }


}
