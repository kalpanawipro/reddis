resource "aws_db_instance" "rds_db_cretion" {
  apply_immediately			            = true
  skip_final_snapshot                   = true
  allocated_storage                     = "500"
  auto_minor_version_upgrade            = "false"
  backup_retention_period               = "0"
  ca_cert_identifier                    = "rds-ca-rsa4096-g1"
  copy_tags_to_snapshot                 = "true"
  customer_owned_ip_enabled             = "false"
  db_name                               = "postgres_db"
  db_subnet_group_name                  = var.subnet_group_name
  deletion_protection                   = "false"
  enabled_cloudwatch_logs_exports       = ["postgresql"]
  engine                                = var.engine_val #substr(element(split("|", each.key), 1), 0 , length(element(split("|", each.key), 1))) #"postgres"
  engine_version                        = var.engine_version_val #substr(element(split(":", each.key), 1), 0 , length(element(split("|",substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1))) ), 0)))
  iam_database_authentication_enabled   = "false"
  identifier                            = var.cluster_identifier #substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))  #var.identifier #"density-sg-eventlog-pg"
  password                              = var.secretPassword #"QNL2UVQ55F5PA"
  instance_class                        = var.instance_class #"db.m4.large"
  license_model                         = var.license_model #"postgresql-license"
  maintenance_window                    = var.maintainence_window #"thu:04:24-thu:04:54"
  max_allocated_storage                 = "0"
  monitoring_interval                   = "0"
  multi_az                              = "true"
  network_type                          = "IPV4"
  option_group_name                     = "default:postgres-14"
  parameter_group_name                  = var.parameter_group_name
  performance_insights_enabled          = "false"
  performance_insights_retention_period = "0"
  port                                  = "5432"
  publicly_accessible                   = "false"
  storage_encrypted                     = "true"
  storage_type                          = "io1"
  iops                                  = 1000
  tags = {
    app  = "infra"
    env  = "dnas"
  }

  tags_all = {
    app  = "infra"
    env  = "dnas"
  }

  username               = "postgres"
  vpc_security_group_ids = var.security_groups_rds
}