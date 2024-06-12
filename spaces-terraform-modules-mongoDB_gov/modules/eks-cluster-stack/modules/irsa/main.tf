data "aws_region" "current" {}

module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.environment}-${lookup(local.regions, data.aws_region.current.name)}-${var.role_name}-IRSA"
  role_path = "/eks/"
  role_policy_arns = {
    policy = module.iam_policy.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["*:${var.role_name}-sa"]
    }
  }
  assume_role_condition_test = "StringLike"
}

module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "${var.environment}-${lookup(local.regions, data.aws_region.current.name)}-${var.role_name}-policy"
  path = "/eks/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ${jsonencode(var.allowed_actions)},
      "Effect": "Allow",
      "Resource": ${jsonencode(var.resources)}
    }
  ]
}
EOF
}
