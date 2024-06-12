resource "kubernetes_namespace_v1" "istio_system" {
  count = var.enable_istio ? 1 : 0
  metadata {
    name = "istio-system"
  }
}

module "eks_blueprints_addons_istio" {
  count   = var.enable_istio ? 1 : 0
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  # This is required to expose Istio Ingress Gateway

  helm_releases = {
    istio-base = {
      chart      = "base"
      version    = local.istio_chart_version
      repository = local.istio_chart_url
      name       = "istio-base"
      namespace  = kubernetes_namespace_v1.istio_system[0].metadata[0].name
    }

    istiod = {
      chart      = "istiod"
      version    = local.istio_chart_version
      repository = local.istio_chart_url
      name       = "istiod"
      namespace  = kubernetes_namespace_v1.istio_system[0].metadata[0].name

      set = [
        {
          name  = "meshConfig.accessLogFile"
          value = "/dev/stdout"
        }
      ]
    }

    istio-ingress = {
      chart            = "gateway"
      version          = local.istio_chart_version
      repository       = local.istio_chart_url
      name             = "istio-ingress"
      namespace        = "istio-ingress" # per https://github.com/istio/istio/blob/master/manifests/charts/gateways/istio-ingress/values.yaml#L2
      create_namespace = true

      values = [
        yamlencode(
          {
            labels = {
              istio = "ingressgateway"
            }
            service = {
              annotations = {
                "service.beta.kubernetes.io/aws-load-balancer-type"       = "nlb"
                "service.beta.kubernetes.io/aws-load-balancer-scheme"     = "internet-facing"
                "service.beta.kubernetes.io/aws-load-balancer-attributes" = "load_balancing.cross_zone.enabled=true"
              }
            }
          }
        )
      ]
    }
  }

  depends_on = [module.eks, module.eks_blueprints_addons]
}

#tetrate istio setup add here

module "eks_blueprint_addons_tetrate_istio" {
  count  = var.enable_tetrate_istio ? 1 : 0
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id        = module.eks.cluster_name
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_version   = module.eks.cluster_version
  eks_oidc_provider     = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  enable_tetrate_istio = true

  tetrate_istio_install_cni     = false
  tetrate_istio_install_gateway = true
  tetrate_istio_version         = "1.20.2"

  tetrate_istio_istiod_helm_config = {
    set_sensitive = [
      {
        name  = "global.imagePullSecrets[0]"
        value = "tetrate-docker-cred"
      },
      {
        name  = "global.hub",
        value = "fips-containers.istio.tetratelabs.com"
      }
    ]
  }

  tetrate_istio_base_helm_config = {
    set_sensitive = [
      {
        name  = "global.imagePullSecrets[0]"
        value = "tetrate-docker-cred"
      },
      {
        name  = "global.hub",
        value = "fips-containers.istio.tetratelabs.com"
      }
    ]
  }

  tetrate_istio_gateway_helm_config = {
    set_sensitive = [
      {
        name  = "service.type"
        value = "NodePort"
      }
    ]
  }
}


data "aws_secretsmanager_secret_version" "tetrate_secret" {
  count     = var.enable_tetrate_istio ? 1 : 0
  secret_id = var.tetrate_custom_configs.tetrate_apikey
}

resource "kubernetes_secret" "tetrate_secret" {
  count = var.enable_tetrate_istio ? 1 : 0
  metadata {
    name      = "tetrate-docker-cred"
    namespace = "istio-system"
  }

  data = {
    ".dockerconfigjson" = data.aws_secretsmanager_secret_version.tetrate_secret[0].secret_string
  }

  type = "kubernetes.io/dockerconfigjson"
}
