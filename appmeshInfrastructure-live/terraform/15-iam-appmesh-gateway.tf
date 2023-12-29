data "aws_iam_policy_document" "appmesh-gateway" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace("aws_iam_openid_connect_provider.eks.url", "http://", "")}:sub"
      values   = [system:serviceaccount:gateway:appmesh-gateway]
    }
    principals {
      type        = "Federated"
      identifiers = ["aws_iam_openid_connect_provider.eks.arn"]
    }
  }
}

resource "aws_iam_role" "appmesh-gateway" {
  name               = "${locals.eks_cluster_name}-appmesh-gateway"
  assume_role_policy = "${data.aws_iam_policy_document.appmesh-gateway.json}"
}

resource "aws_iam_policy_document" "aws_cloud_map_full_access_gateway" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudMapFullAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_full_access_gateway" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshFullAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_gateway_controller_access" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshGatewayControllerAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_mesh_gateway_access" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshMeshGatewayAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_virtual_node_gateway_access" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshVirtualNodeGatewayAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_virtual_router_gateway_access" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshVirtualRouterGatewayAccess"
}

resource "aws_iam_policy_document" "aws_appmesh_virtual_service_gateway_access" {
  role = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshVirtualServiceGatewayAccess"
}

resource "aws_iam_role_policy_attachment" "aws_cloud_map_full_access_gateway" {
  role       = "${aws_iam_role.appmesh-gateway.name}"
  policy_arn = "${aws_iam_policy_document.aws_cloud_map_full_access_gateway.policy_arn}"
}

depends_on = [
  aws_iam_openid_connect_provider.eks,
]

