resource "aws_neptune_cluster" "neptunedb_create" {
  cluster_identifier                  = var.cluster_identifier
  engine                              = "neptune"
  engine_version                      = "1.3.0.0"
  backup_retention_period             = 1
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  apply_immediately                   = true
  vpc_security_group_ids             = var.vpc_security_group_neptunedb
  neptune_subnet_group_name          = var.neptune_subnet_group_name    #aws_db_subnet_group.neptuneSubnetGroup.id
  neptune_cluster_parameter_group_name = "sandboxgovcloudneptunedb-cluster-param-group"     #aws_neptune_cluster_parameter_group.neptune_cluster_param_group.id #"default.neptune1.3"
  tags = {
    Name        = var.cluster_identifier
    Environment = "sandbox"
  }
}

resource "aws_neptune_cluster_instance" "neptune_cluster_add" {
  count              = var.num_instance 
  cluster_identifier = aws_neptune_cluster.neptunedb_create.cluster_identifier
  identifier         = "${aws_neptune_cluster.neptunedb_create.cluster_identifier}-${count.index}"
  engine             = "neptune"
  instance_class     = var.instance_class 
  apply_immediately  = true
  neptune_subnet_group_name          = var.neptune_subnet_group_name     #aws_db_subnet_group.neptuneSubnetGroup.id
  neptune_parameter_group_name       = "sandboxgovcloudneptunedb-instance-param-group"   #aws_neptune_parameter_group.neptune_param_group.id
  tags = {
    Name        = "${var.cluster_identifier}-${count.index}"
    Environment = "sandbox"
  }

}



# resource "aws_neptune_parameter_group" "neptune_param_group" {
#   family = "neptune"
#   name   = "neptunedb-param-group"

#   parameter {
#     name  = "neptune_query_timeout"
#     value = "25"
#   }
# }

# resource "aws_neptune_cluster_parameter_group" "neptune_cluster_param_group" {
#   family      = "neptune"
#   name        = "neptunedb-cluster-param-group"
#   description = "neptune cluster parameter group"

#   parameter {
#     name  = "neptune_enable_audit_log"
#     value = 1
#   }
# }
