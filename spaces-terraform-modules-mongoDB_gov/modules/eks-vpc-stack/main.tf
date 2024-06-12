# - EKS VPC module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets #[for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = var.public_subnets  #[for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = var.public_subnet_tags

  private_subnet_tags = var.private_subnet_tags

  tags = var.tags
}
