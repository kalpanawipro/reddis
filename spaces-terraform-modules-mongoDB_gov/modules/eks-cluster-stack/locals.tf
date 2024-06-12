# Istion Addon Locals
locals {
  istio_chart_url     = "https://istio-release.storage.googleapis.com/charts"
  istio_chart_version = "1.18.1"

  policies = [
    aws_iam_policy.secret_access.arn,
    "arn:aws-us-gov:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws-us-gov:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws-us-gov:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws-us-gov:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  managed_node_group_configs = {
    for key, config in var.eks_managed_node_groups :
    "${key}" => {
      min_size                   = config.min_size
      max_size                   = config.max_size
      desired_size               = config.desired_size
      instance_types             = config.instance_types
      capacity_type              = config.capacity_type
      labels                     = config.labels
      use_custom_launch_template = true
      create_launch_template     = false
      launch_template_id         = try(config.launch_template_id, aws_launch_template.custom_launch_template.id)
      launch_template_version    = try(config.launch_template_version, 1)
      create_iam_role            = false
      iam_role_arn               = aws_iam_role.eks_node_role.arn
    }
  }

  # mgmt_cluster = {
  #   cluster_endpoint = var.register_as_spoke ? try(data.terraform_remote_state.mgmt_cluster[0].outputs.cluster_endpoint, module.eks.cluster_endpoint) : module.eks.cluster_endpoint

  #   cluster_ca_certificate = var.register_as_spoke ? try(data.terraform_remote_state.mgmt_cluster[0].outputs.cluster_certificate_authority_data, module.eks.cluster_certificate_authority_data) : module.eks.cluster_certificate_authority_data
    
  #   cluster_name = var.register_as_spoke ? try(data.terraform_remote_state.mgmt_cluster[0].outputs.cluster_name, module.eks.cluster_name) : module.eks.cluster_name
    
  #   role_arn = var.register_as_spoke ? var.management_cluster_state.role_arn : var.assume_role
  # }
}

