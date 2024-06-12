resource "aws_redshift_cluster" "loc_redshift_cluster" {
  for_each = toset(var.cluster_identifier)
  #["loc_redshift_cluster:1.0:ra3.xlplus"]
  allow_version_upgrade               = true
  automated_snapshot_retention_period = 1
  availability_zone                   = var.availability_zone
  cluster_identifier                  = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))  
  cluster_parameter_group_name        = aws_redshift_parameter_group.loc_redshift_cluster_parameter_group.id #"prod-redshift-parameter-group"
  cluster_public_key                  = var.cluster_public_key #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCFmhHLb0lguyx9ngg6C7nYLYfGn1nAm9t7+viYIKS55p1xHh1PWK9luc2sN+e+28F3HLiYz1OxSyjzyr4Gt41r4/9J/HhgNk7UdNG/H7wBbjJyxWThXlxDNNqHaXL8C8g2w6h5btYJvWymE06bv7ye8CcmWvbx6881jGnj8yfnJaa8eiq26gL2qSfPAECIG6hBa+cxgXvXXMKXhZmq3BxKC5n3sXT9l2ctmstvVO35nL5Fk8PxKPgiErFqZMG6bSKNFcBIk6AVYHmfLV4cXq/6ZOg64Z4n8i4Qo+xtUWWz17YVOmKufvA94j+vU9XZmyWnSwcdA+anw8SGnL1u0D03 Amazon-Redshift"
  cluster_revision_number             = "61626"
  cluster_subnet_group_name           = aws_redshift_subnet_group.loc_redshift_cluster_subnet_group.id #"prod-redshift-subnet-group"
  cluster_type                        = var.cluster_type #"multi-node"
  cluster_version                     = "1.0"  #substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))     #substr(element(split(":", each.key), 1), 0 , length(element(split(":",substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1))) ), 0))) #"1.0"
  database_name                       = "dev"
  iam_roles                           = var.iam_roles #["arn:aws:iam::705697098806:role/history-redshift-role"]
  master_password                     = var.master_password #"qNL2UVQ55F5PA"
  logging {
    enable = false
  }

  master_username                     = var.master_username #"admin"
  node_type                           = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2))) #"ra3.xlplus"
  number_of_nodes                     = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))  #var.number_of_nodes #2
  port                                = "5439"
  preferred_maintenance_window        = "mon:04:00-mon:04:30"
  publicly_accessible                 = false
  skip_final_snapshot                 = true
  vpc_security_group_ids              = var.security_groups #["sg-0a55b64c0e45672ef", "sg-001fcf8918cde4ba8"]
}


resource "aws_redshift_subnet_group" loc_redshift_cluster_subnet_group {
    subnet_ids                        = var.subnet_ids #["subnet-037e4acc201a1306c", "subnet-01d772cacb4dab399"]
    name                              = "sandbox-redshift-subnet-group"
}

resource "aws_redshift_parameter_group" "loc_redshift_cluster_parameter_group" {
  name   = "redshift-cluster-parameter-group"
  family = "redshift-1.0"

  parameter {
    name  = "require_ssl"
    value = "true"
  }

  parameter {
    name  = "query_group"
    value = "test"
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "use_fips_ssl"
    value = "true"
  }
}