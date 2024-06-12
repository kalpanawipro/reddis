module rds_db_cretion {
    source = "../modules/rds/"
    for_each = toset(var.identifier)
    secretPassword                        = var.secretPassword #"QNL2UVQ55F5PA"
    instance_class                        = var.instance_class #"db.m4.large"
    license_model                         = var.license_model #"postgresql-license"
    maintainence_window                   = var.maintainence_window
    subnet_id_rds                         = var.subnet_id_rds
    subnet_group_name                     = aws_db_subnet_group.rdssgsubnet.id
    security_groups_rds                   = var.security_groups_rds
    engine_val                            = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2)))  #var.number_of_nodes #2 substr(element(split("|", each.key), 1), 0 , length(element(split("|", each.key), 1))) #"postgres"
    engine_version_val                    = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))  #var.number_of_nodes #2 #substr(element(split(":", each.key), 1), 0 , length(element(split("|",substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1))) ), 0)))
    cluster_identifier                    = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))  #var.identifier #"density-sg-eventlog-pg"
    parameter_group_name                  = aws_db_parameter_group.custom-postgres14.id
}

module rds_cluster_creation {
    source = "../modules/rds_cluster/"
    for_each = toset(var.aurora_identifier)
    subnet_id_rds                         = var.subnet_id_rds
    security_groups_rds                   = var.security_groups_rds
    #aurora_identifier                     = var.aurora_identifier
    cluster_identifier                    = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))  
    engine                                = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2)))   #substr(element(split("|", each.key), 1), 0 , length(element(split("|", each.key), 1))) #"postgres"
    engine_version                        = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))   #substr(element(split(":", each.key), 1), 0 , length(element(split("|",substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1))) ), 0))) #"13.6"
    instance_class                        = substr(element(split(":", each.key), 3), 0 , length(element(split(":", each.key), 3)))  
    db_subnet_group_name     = aws_db_subnet_group.rdssgsubnet.id
}

resource "aws_db_subnet_group" "rdssgsubnet" {
  description = "rdssgsubnet"
  name        = var.subnet_group_name
  subnet_ids  = var.subnet_id_rds
}


resource "aws_db_parameter_group" "custom-postgres14" {
  description = "custom-postgres14"
  family      = "postgres14"
  name        = "custom-postgres14"

  parameter {
    apply_method = "immediate"
    name         = "log_statement"
    value        = "mod"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "rds.logical_replication"
    value        = "1"
  }
}