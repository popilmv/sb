locals {
  cluster_name = "sandbox"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = local.cluster_name
  cluster_version = "1.25"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  # cluster_addons = {
  #   aws-ebs-csi-driver = {
  #     addon_version            = "v1.15.0-eksbuild.1"
  #     service_account_role_arn = module.ebs_role.iam_role_arn
  #   }
  # }

  # manage_aws_auth_configmap = true
  # aws_auth_roles            = concat(
  #   [
  #     for i in var.admin_roles : {
  #     username = i.name
  #     rolearn  = i.arn
  #     groups   = [
  #       "system:masters"
  #     ]
  #   }
  #   ],
  #   [
  #     for i in var.teamlead_roles : {
  #     username = i.name
  #     rolearn  = i.arn
  #     groups   = [
  #       "system:teamlead"
  #     ]
  #   }
  #   ],
  #   [
  #     for i in var.ro_roles : {
  #     username = i.name
  #     rolearn  = i.arn
  #     groups   = [
  #       "system:viewer"
  #     ]
  #   }
  #   ],
  # )

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
  }

eks_managed_node_groups = {
  ingress = {
    name = "ingress"
    subnet_ids = ["subnet-04008fe19744ffa18", "subnet-0d7d50dc41c735e3d", "subnet-076380efb644ce7f1"]
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]

    min_size     = 1
    max_size     = 2
    desired_size = 2
    labels       = {
      "nodegroup-name" = "ingress"
    }

    taints = [
      {
        key    = "ingress"
        effect = "NO_SCHEDULE"
      }
    ]

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs         = {
          volume_size           = 10
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }

  main = {
    name = "main"
    subnet_ids = ["subnet-04008fe19744ffa18", "subnet-0d7d50dc41c735e3d", "subnet-076380efb644ce7f1"]
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]

    min_size     = 1
    max_size     = 2
    desired_size = 2

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs         = {
          volume_size           = 10
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }
  sb = {
    name = "sb"
    # subnet_ids = ["subnet-0996ed421a40f5ac1", "subnet-0a3d2920160021d4f", "subnet-06ee7c62303152939", "subnet-044531a5881f70f69", "subnet-040cdd4fca46fec23", "subnet-0ef45c713081a7b70" ]
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]

    min_size     = 1
    max_size     = 2
    desired_size = 2

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs         = {
          volume_size           = 10
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    }
  }
}
}
# data "aws_eks_cluster" "default" {
#   #  depends_on = [module.eks.eks_managed_node_groups]
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "default" {
#   #  depends_on = [module.eks.eks_managed_node_groups]
#   name = module.eks.cluster_name
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.default.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.default.token
# }

# # check where a1 instances are available
# data "aws_ec2_instance_type_offerings" "a1" {
#   filter {
#     name   = "instance-type"
#     values = ["a1.large"]
#   }
#   location_type = "availability-zone"
# }

# # get private subnets in those AZs
# data "aws_subnets" "a1" {
#   depends_on = [module.vpc]
#   filter {
#     name   = "vpc-id"
#     values = [module.vpc.vpc_id]
#   }

#   tags = {
#     tier = "private"
#   }

#   filter {
#     name   = "availability-zone"
#     values = data.aws_ec2_instance_type_offerings.a1.locations
#   }
# }
