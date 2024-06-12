resource "aws_iam_policy" "secret_access" {
  name = "${var.environment}-secret-access-for-volumes"
  path = "/eks/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-${var.environment}-EKS-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role_attachment" {
  for_each   = { for i, val in local.policies : i => val }
  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}
