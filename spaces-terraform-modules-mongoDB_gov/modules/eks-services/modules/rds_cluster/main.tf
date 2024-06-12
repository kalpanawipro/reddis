resource "aws_rds_cluster" "rds_cluster_instance" {
  cluster_identifier = var.cluster_identifier #substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))  
  engine             = var.engine #substr(element(split("|", each.key), 1), 0 , length(element(split("|", each.key), 1))) #"postgres"
  engine_mode        = "provisioned"
  engine_version     = var.engine_version #substr(element(split(":", each.key), 1), 0 , length(element(split("|",substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1))) ), 0))) #"13.6"
  database_name      = "aurora_db"
  master_username    = "test"
  master_password    = "must_be_eight_characters"
  storage_encrypted  = true
  skip_final_snapshot= true
  vpc_security_group_ids = var.security_groups_rds
  # db_cluster_instance_class = "db.r6g.12xlarge"
  db_subnet_group_name = var.db_subnet_group_name
}
resource "aws_rds_cluster_instance" "cluster_instance" {
  count = 2
  identifier = "${aws_rds_cluster.rds_cluster_instance.id}-${count.index}"
  cluster_identifier = aws_rds_cluster.rds_cluster_instance.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.rds_cluster_instance.engine
  engine_version     = aws_rds_cluster.rds_cluster_instance.engine_version
  db_subnet_group_name = var.db_subnet_group_name
  
}