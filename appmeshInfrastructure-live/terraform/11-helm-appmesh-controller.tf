data "aws_eks_cluster" "eks" {
  name = locals.eks_cluster_name

  depends_on = [
    aws_eks_cluster.eks,
  ]
}

data "aws_eks_cluster_auth" "eks" {
  name = local.eks_cluster_name

    depends_on = [
        aws_eks_cluster.eks,
    ]
}

provider "helm" {
    kubernetes {
        host                   = data.aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
        token                  = data.aws_eks_cluster_auth.eks.token
    }
}

resource "helm_release" "appmesh_controller" {
  name       = "appmesh-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "appmesh-controller"
  namespace  = "appmesh-system"
  create_namespace = true
  version    = "1.12.7"

  set {
    name  = "serviceaccount.name"
    value = "appmesh-controller"
  }

  set {
    name  = "serviceaccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.appmesh_controller.arn
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.general,
    aws_iam_role_policy_attachment.aws_cloud_map_full_access_controller,
    aws_iam_role_policy_attachment.aws_appmesh_full_access_controller
  ]
}