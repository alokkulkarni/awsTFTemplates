provider "kubectl" {
    host = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.eks_cluster.token
    load_config_file = false
}

resource "kubectl_manifest" "mesh" {
    yaml_body = file("../k8s/mesh.yaml")
    depends_on = [helm_release.appmesh_controller]
}