# # - EKS VPC module

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 5.0"
#   create_vpc = false

#   name = var.name
#   cidr = var.vpc_cidr

#   azs             = var.azs
#   private_subnets = var.private_subnets #[for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k)]
#   public_subnets  = var.public_subnets  #[for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

#   enable_nat_gateway = true
#   single_nat_gateway = true

#   public_subnet_tags = var.public_subnet_tags

#   private_subnet_tags = var.private_subnet_tags

#   tags = var.tags
# }

# Subnets
# Internet Gateway for Public Subnet
# resource "aws_internet_gateway" "ig" {
#   vpc_id = var.vpc_id
#   tags = {
#     Name        = "spaces-${var.environment}-igw"
#     Environment = var.environment
#   }
# }

# # Elastic-IP (eip) for NAT
# resource "aws_eip" "nat_eip" {
#   domain     = "vpc"
#   depends_on = [aws_internet_gateway.ig]
# }

# # NAT
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

#   tags = {
#     Name        = "nat"
#     Environment = "spaces-${var.environment}"
#   }
# }

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "spaces-${element(var.azs, count.index)}-public-subnet"
    Environment = "spaces-${var.environment}"
    "kubernetes.io/role/elb" = 1
  }
}


# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.vpc_id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "spaces-${element(var.azs, count.index)}-private-subnet"
    Environment = "spaces-${var.environment}"
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery" = "private"
  }
}


# Routing tables to route traffic for Private Subnet
# resource "aws_route_table" "private" {
#   vpc_id = var.vpc_id

#   tags = {
#     Name        = "spaces-${var.environment}-private-route-table"
#     Environment = "spaces-${var.environment}"
#     Terraform = "true"
#   }
# }

# # Routing tables to route traffic for Public Subnet
# resource "aws_route_table" "public" {
#   vpc_id = var.vpc_id

#   tags = {
#     Name        = "spaces-${var.environment}-public-route-table"
#     Environment = "spaces-${var.environment}"
#     Terraform = "true"
#   }
# }

# # Route for Internet Gateway
# resource "aws_route" "public_internet_gateway" {
#   route_table_id         = var.public_route_table  #aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.ig.id
# }

# # # Route for NAT
# resource "aws_route" "private_nat_gateway" {
#   route_table_id         = var.public_route_table #aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = var.public_route_table
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = var.private_route_table
}
