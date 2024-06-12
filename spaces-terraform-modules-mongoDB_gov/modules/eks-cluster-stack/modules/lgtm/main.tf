data "aws_region" "current" {}

resource "aws_s3_bucket" "loki_s3_bucket" {
  bucket = "${var.environment}-${var.loki_bucket_name}"
    force_destroy = true

}

resource "aws_s3_bucket_public_access_block" "loki_s3_bucket_access_block" {
  bucket = aws_s3_bucket.loki_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "loki_irsa" {
  source                = "../irsa"
  role_name             = "loki-s3-role"
  allowed_actions       = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket"]
  resources             = ["${aws_s3_bucket.loki_s3_bucket.arn}*"]
  eks_oidc_provider_arn = var.eks_oidc_provider_arn
  environment           = var.environment
}

resource "helm_release" "grafana_loki" {
  name             = "loki"
  create_namespace = true
  namespace        = "loki-stack"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"

  values = [
    templatefile("${path.module}/values/loki_values.yaml", {
      irsa_arn   = module.loki_irsa.iam_role_arn,
      bucketname = "${var.environment}-${var.loki_bucket_name}",
      sa_name    = "loki-s3-role-sa",
      region     = data.aws_region.current.name
    })
  ]
}

resource "kubectl_manifest" "grafana_loki_ingress" {
  yaml_body = templatefile("${path.module}/values/ingress.yaml", {
    acm_certificate_arn = var.acm_certificate_arn
  })
}
