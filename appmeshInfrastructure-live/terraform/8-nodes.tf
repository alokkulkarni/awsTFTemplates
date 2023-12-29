resource "aws_iam_role" "nodes" {
    name = "${locals.eks_cluster_name}-nodes"
    assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.nodes.name
} 

resource "aws_iam_instance_profile" "nodes" {
    name = "${locals.eks_cluster_name}-nodes"
    role = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "general" {
    cluster_name    = aws_eks_cluster.eks_cluster.name
    version         = aws_eks_cluster.eks_cluster.version
    node_group_name = "${locals.eks_cluster_name}-general"
    node_role_arn   = aws_iam_role.nodes.arn
    subnet_ids      = [
        aws_subnet.private_zone1.id,
        aws_subnet.private_zone2.id
    ]
    capacity_type   = "ON_DEMAND"
    instance_types  = ["t3.small"]
    scaling_config {
        desired_size = 1
        max_size     = 5
        min_size     = 1
    }
    update_config {
        max_unavailable = 1
    }
    labels = {
        "role" = "general"
    }
    tags = {
        "nodegroup-role" = "general"
    }

    depends_on = [
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
    ]

    lifecycle {
        ignore_changes = [
            scaling_config[0].desired_size
        ]
    }
}