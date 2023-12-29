resource "aws_subnet" "private_zone1" {
    vpc_id     = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.0.0/19"
    availability_zone = locals.zone1
    tags = {
        Name = locals.zone1
        kubernetes.io/role/internal-elb = "1"
        kubernetes.io/cluster/"${locals.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private_zone2" {
    vpc_id     = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.32.0/19"
    availability_zone = locals.zone2
    tags = {
        Name = locals.zone2
        kubernetes.io/role/internal-elb = "1"
        kubernetes.io/cluster/"${locals.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone1" {
    vpc_id     = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.64.0/19"
    availability_zone = locals.zone1
    map_public_ip_on_launch = true
    tags = {
        Name = locals.zone1
        kubernetes.io/role/elb = "1"
        kubernetes.io/cluster/"${locals.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone2" {
    vpc_id     = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.96.0/19"
    availability_zone = locals.zone2
    map_public_ip_on_launch = true
    tags = {
        Name = locals.zone2
        kubernetes.io/role/elb = "1"
        kubernetes.io/cluster/"${locals.eks_cluster_name}" = "owned"
    }
}


