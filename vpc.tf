locals {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "test-vpc"

  cidr = "10.1.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = [
    cidrsubnet("10.1.0.0/16", 8, 1),
    cidrsubnet("10.1.0.0/16", 8, 2),
    cidrsubnet("10.1.0.0/16", 8, 3),
    cidrsubnet("10.1.0.0/16", 4, 7),
    cidrsubnet("10.1.0.0/16", 4, 8),
    cidrsubnet("10.1.0.0/16", 4, 9)
  ]
  public_subnets  = [
    cidrsubnet("10.1.0.0/16", 8, 4),
    cidrsubnet("10.1.0.0/16", 8, 5),
    cidrsubnet("10.1.0.0/16", 8, 6)
  ]

  create_database_subnet_group = true

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = [aws_eip.eip1.id, aws_eip.eip2.id, aws_eip.eip3.id,aws_eip.eip4.id, aws_eip.eip5.id, aws_eip.eip6.id]

  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/test" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "tier"                                        = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/test" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "tier"                                        = "private"
  }
}

data "aws_availability_zones" "available" {}

# prod 3.69.186.72
resource "aws_eip" "eip1" {
  tags = {
    Name = "eip1"
  }
  vpc = true
}

# prod 3.124.27.53
resource "aws_eip" "eip2" {
  vpc = true
  tags = {
    Name = "eip2"
  }
}

resource "aws_eip" "eip3" {
  vpc = true
  tags = {
    Name = "eip3"
  }
}
resource "aws_eip" "eip4" {
  vpc = true
  tags = {
    Name = "eip4"
  }
}
resource "aws_eip" "eip5" {
  vpc = true
  tags = {
    Name = "eip5"
  }
}
resource "aws_eip" "eip6" {
  vpc = true
  tags = {
    Name = "eip6"
  }
}
