variable "node_port_services" {
  type = map(object({
    port : number
    target_port : number
    healthcheck_path : optional(string)
    healthcheck_protocol : optional(string)
  }))

  default = {}
}

variable "node_port_services-2" {
  type = map(object({
    port : number
    target_port : number
    healthcheck_path : optional(string)
    healthcheck_protocol : optional(string)
  }))

  default = {}
}

variable "node_port_services_autoscaling_groups" {
  type    = list(string)
  default = []
}

variable "node_port_services_asg_name" {
  type    = string
  default = ""
}

resource "aws_security_group" "node-port-services-lb" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "Internal traffic from the VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "To VPC CIDR block"
  }
}

resource "aws_lb" "node_port_services" {
  name               = "node-port-services"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.vpc.private_subnets
  # subnets            = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
  security_groups    = [aws_security_group.node-port-services-lb.id]

  enable_deletion_protection = false
}
