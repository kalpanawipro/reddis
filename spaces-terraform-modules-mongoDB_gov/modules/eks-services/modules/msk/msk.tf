resource "aws_msk_cluster" "sgwebex-api-cluster" {
  broker_node_group_info {
    az_distribution = "DEFAULT"
    client_subnets  = var.subnet_id_msk

    connectivity_info {
      public_access {
        type = "DISABLED"
      }
    }
    storage_info {
      ebs_storage_info {
        volume_size = "1000"
      }
    }

    instance_type   = var.msk_instanceType
    security_groups = var.security_groups_msk
}

  client_authentication {
    tls {
      certificate_authority_arns = ["arn:aws-us-gov:acm-pca:us-gov-west-1:031661760457:certificate-authority/458ce047-a7ca-4f23-9287-12f16544913b"]
    }

    unauthenticated = "false"
  }

  cluster_name = var.clusterName #"sgwebex-api-cluster"
  dynamic encryption_info {
    for_each = var.encryptionInfo=="false" ? [1] : []
    content {
    encryption_at_rest_kms_key_arn = "arn:aws-us-gov:kms:us-gov-west-1:031661760457:key/054eb9e3-713b-42ca-a962-52cee46e0304"
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster    = "false"
    }
    }
  }

  enhanced_monitoring = "DEFAULT"
  kafka_version       = "2.6.1"

  number_of_broker_nodes = var.totalNodeMsk
}