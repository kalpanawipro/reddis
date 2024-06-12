module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  # version = "1.8.0" #ensure to update this to the latest/desired version"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  #eks_addons = var.eks_addons

  enable_aws_efs_csi_driver                    = try(var.enable_aws_efs_csi_driver, false)
  enable_aws_fsx_csi_driver                    = try(var.enable_aws_fsx_csi_driver, false)
  enable_argocd                                = try(var.enable_argocd, false)
  enable_argo_rollouts                         = try(var.enable_argo_rollouts, false)
  enable_argo_workflows                        = try(var.enable_argo_workflows, false)
  enable_aws_cloudwatch_metrics                = try(var.enable_aws_cloudwatch_metrics, false)
  enable_aws_privateca_issuer                  = try(var.enable_aws_privateca_issuer, false)
  enable_cert_manager                          = try(var.enable_cert_manager, false)
  enable_cluster_autoscaler                    = try(var.enable_cluster_autoscaler, false)
  enable_secrets_store_csi_driver              = try(var.enable_secrets_store_csi_driver, false)
  enable_secrets_store_csi_driver_provider_aws = try(var.enable_secrets_store_csi_driver_provider_aws, false)
  enable_kube_prometheus_stack                 = try(var.enable_kube_prometheus_stack, false)
  enable_external_dns                          = try(var.enable_external_dns, false)
  enable_external_secrets                      = try(var.enable_external_secrets, false)
  enable_gatekeeper                            = try(var.enable_gatekeeper, false)
  enable_aws_load_balancer_controller          = try(var.enable_aws_load_balancer_controller, false)
  enable_karpenter                             = try(var.enable_karpenter, false)
  karpenter_node = var.enable_karpenter ? {
    create_iam_role       = false
    iam_role_arn          = aws_iam_role.karpenter_node_role[0].arn
    iam_role_name         = aws_iam_role.karpenter_node_role[0].name
    instance_profile_name = aws_iam_instance_profile.karpenter_instance_profile[0].name
  } : {}
  # enable_aws_for_fluentbit                     = try(var.enable_aws_for_fluentbit, false)

  helm_releases = {
    openebs = try(var.enable_openebs, false) ? {
      description      = "Containerized Attached Storage for Kubernetes"
      namespace        = "openebs"
      create_namespace = true
      chart            = "openebs"
      chart_version    = "3.9.0"
      repository       = "https://openebs.github.io/charts"
      values = [
        <<-EOT
          localprovisioner:
            hostpathClass:
              name: openebs-hostpath-xfs
              basePath: /eksmounts/
              xfsQuota:
                enabled: true
        EOT
      ]
    } : null
  }

  tags = var.tags

  argocd = {
    values = [templatefile("${path.module}/configs/argocd_values.yaml", {})]
  }

}

resource "kubectl_manifest" "local_volume_node_cleanup_controller" {
  count     = try(var.enable_volume_cleanup, false) ? 1 : 0
  yaml_body = file("${path.module}/configs/local_volume_node_cleanup_controller.yaml")
}

data "kubectl_path_documents" "local_volume_node_cleanup_controller_rbac" {
  pattern = "${path.module}/configs/local_volume_node_cleanup_controller_rbac.yaml"
}

resource "kubectl_manifest" "local_volume_node_cleanup_controller_rbac" {
  for_each  = try(var.enable_volume_cleanup, false) ? toset(data.kubectl_path_documents.local_volume_node_cleanup_controller_rbac.documents) : toset([])
  yaml_body = each.value
}

data "aws_secretsmanager_secret_version" "argocd_secret" {
  count     = var.enable_argocd ? 1 : 0
  secret_id = var.argocd_configs.gitlab_token_secret_arn
}

resource "kubernetes_secret" "argocd_secret" {
  count = var.enable_argocd ? 1 : 0
  metadata {
    name      = "gitlab-token"
    namespace = "argocd"
  }

  data = {
    token = data.aws_secretsmanager_secret_version.argocd_secret[0].secret_string
  }
}



## Karpenter ##
resource "kubectl_manifest" "karpenter_provisioner" {
  count = var.enable_karpenter ? 1 : 0
  yaml_body = templatefile("${path.module}/configs/karpenter_manifest_provisioner.yml", {
    karpenter_cpu_limit             = try(var.karpenter_configs.cpu_limit, "1000")
    karpenter_memory_limit          = try(var.karpenter_configs.memory_limit, "1000Gi")
    karpenter_instance_types        = jsonencode(try(var.karpenter_configs.instance_types, ["i3.large", "i3.xlarge"]))
    karpenter_instance_architecture = jsonencode(try(var.karpenter_configs.instance_architecture, ["amd64"]))
    karpenter_capacity_type         = jsonencode(try(var.karpenter_configs.capacity_type, ["on-demand"]))
    karpenter_consolidation         = jsonencode(try(var.karpenter_configs.consolidation, true))
    karpenter_labels                = jsonencode(try(var.karpenter_configs.labels, { intent = "apps" }))
  })
  depends_on = [
    module.eks_blueprints_addons
  ]
}

resource "kubectl_manifest" "karpenter_nodetemplate" {
  count = var.enable_karpenter ? 1 : 0
  yaml_body = templatefile("${path.module}/configs/karpenter_manifest_nodetemplate.yml", {
    karpenter_node_instance_profile = aws_iam_instance_profile.karpenter_instance_profile[0].name
    karpenter_subnet_tag            = var.karpenter_configs.subnet_tag
    cluster_name                    = module.eks.cluster_name
    karpenter_userdata              = indent(4, file("${path.module}/configs/custom_userdata.tmpl"))
    karpenter_node_root_vol_size    = try(var.karpenter_configs.node_root_vol_size, "100Gi")
  })

  depends_on = [
    module.eks_blueprints_addons
  ]
}

resource "aws_iam_role" "karpenter_node_role" {
  count = var.enable_karpenter ? 1 : 0
  name  = "eks-${var.environment}-karpenter-node-role"
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

resource "aws_iam_role_policy_attachment" "karpenter_node_role_attachment" {
  for_each   = var.enable_karpenter ? { for i, val in local.policies : i => val } : {}
  role       = aws_iam_role.karpenter_node_role[0].name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "karpenter_instance_profile" {
  count = var.enable_karpenter ? 1 : 0
  name  = "${var.environment}-karpenter-node"
  path  = "/eks/"
  role  = aws_iam_role.karpenter_node_role[0].name
}


