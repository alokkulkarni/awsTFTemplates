data "aws_iam_policy_document" "appmesh_controller" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        effect  = "Allow"

        condition {
            test     = "StringEquals"
            variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}"
            values   = ["system:serviceaccount:appmesh-system:appmesh-controller"]
        }

        principals {
            identifiers = ["${aws_iam_openid_connect_provider.eks.arn}"]
            type        = "Federated"
        }
    }
}

resource "aws_iam_role" "appmesh_controller" {
    name               = "${locals.eks_cluster_name}-appmesh-controller"
    assume_role_policy = "${data.aws_iam_policy_document.appmesh_controller.json}"
}

resource "aws_iam_role_policy_attachment" "aws_cloud_map_full_access_controller" {
    role       = "${aws_iam_role.appmesh_controller.name}"
    policy_arn = "arn:aws:iam::aws:policy/AWSCloudMapFullAccess"
}

resource "aws_iam_role_policy_attachment" "aws_appmesh_full_access_controller" {
    role       = "${aws_iam_role.appmesh_controller.name}"
    policy_arn = "arn:aws:iam::aws:policy/AWSAppMeshFullAccess"
}