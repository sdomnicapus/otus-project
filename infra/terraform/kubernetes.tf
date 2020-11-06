provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.otus-project.endpoint
  token                  = data.aws_eks_cluster_auth.otus-project.token
  version                = "~> 1.11"
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.otus-project.certificate_authority.0.data)
}

