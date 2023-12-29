data "aws_iam_policy_document" "service_a" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://","")}:sub"
      values   = [
        "system:serviceaccount:service_a:service_a",
      ]
    }

    principals {
      identifiers = [
        "${aws_iam_openid_connect_provider.eks.arn}",
      ]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "service_a" {
  name               = "${locals.eks_cluster_name}-service_a"
  assume_role_policy = "${data.aws_iam_policy_document.service_a.json}"
}


resource "aws_iam_policy" "service_a" {
    name        = "${local.eks_cluster_name}-service_a_access"
    description = "Service A"
    policy      = file("./proxy-auth.json")
}

resource "aws_iam_role_policy_attachment" "service_a" {
  role       = "${aws_iam_role.service_a.name}"
  policy_arn = "${aws_iam_policy.service_a.arn}"
}

output "service_a_role_arn" {
  value = "${aws_iam_role.service_a.arn}"
}