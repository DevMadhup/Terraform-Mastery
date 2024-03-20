data "aws_iam_policy_document" "eks-cluster-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "EKS-Cluster-Role-Terraform" {
  name               = "eks-cluster-role-terraform"
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-role.json
}

resource "aws_iam_role_policy_attachment" "EKS-Cluster-Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKS-Cluster-Role-Terraform.name
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_eks_cluster" "EKS-ClusterTWS" {
  name     = var.clusterName
  role_arn = aws_iam_role.EKS-Cluster-Role-Terraform.arn
  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.EKS-Cluster-Policy,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.EKS-ClusterTWS.endpoint
}


resource "aws_iam_role" "eks-node-group-role" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.EKS-ClusterTWS.name
  node_group_name = "Node-TWS"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = data.aws_subnets.public.ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t2.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
