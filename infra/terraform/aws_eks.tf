resource "aws_eks_cluster" "otus-project" {
  name     = var.cluster_name
  role_arn = aws_iam_role.otus-project.arn
  version  = var.cluster_version

  vpc_config {
    security_group_ids = [aws_security_group.otus-project.id]
    subnet_ids         = aws_subnet.otus-project[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.otus-project-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.otus-project-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "otus-project" {
  cluster_name    = aws_eks_cluster.otus-project.name
  node_group_name = "otus-project"
  node_role_arn   = aws_iam_role.otus-project-node.arn
  subnet_ids      = aws_subnet.otus-project[*].id
  version  = var.cluster_version
  instance_types  = ["t3.small"]
  disk_size       = 70

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    "usecase" = "workload",
    "app" = "redis"
  }

  depends_on = [
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "monitoring" {
  cluster_name    = aws_eks_cluster.otus-project.name
  node_group_name = "monitoring"
  node_role_arn   = aws_iam_role.otus-project-node.arn
  subnet_ids      = aws_subnet.otus-project[*].id
  version  = var.cluster_version
  instance_types  = ["t3.small"]
  disk_size       = 150

  labels = {
    "usecase" = "monitoring"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEC2ContainerRegistryReadOnly,
  ]

}

resource "aws_eks_node_group" "rabbitmq" {
  cluster_name    = aws_eks_cluster.otus-project.name
  node_group_name = "rabbitmq"
  node_role_arn   = aws_iam_role.otus-project-node.arn
  subnet_ids      = aws_subnet.otus-project[*].id
  version  = var.cluster_version
  instance_types  = ["t3.medium"]
  disk_size       = 70

  labels = {
    "usecase" = "rabbitmq"
  }


  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  depends_on = [
    aws_eks_cluster.otus-project,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.otus-project-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}