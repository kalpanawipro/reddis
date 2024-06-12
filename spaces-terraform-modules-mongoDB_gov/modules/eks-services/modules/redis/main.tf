resource "aws_elasticache_replication_group" "gov-cloud-redis" {
  for_each = toset(var.cluster_id)
  description = "Redis clusters creation"
  replication_group_id = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))
  #cluster_id           =  substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))
  engine               = var.engine
  node_type            = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2)))
  num_node_groups      = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))
  parameter_group_name = var.parameter_group_name
  engine_version       = var.engine_version
  port                 = var.port
  # availability_zone    = var.availability_zone[0]
  subnet_group_name    = var.subnet_group_name
  multi_az_enabled = false
  replicas_per_node_group = 1
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  security_group_ids = var.security_group_ids 
}

resource "aws_elasticache_replication_group" "gov-cloud-redis-cluster" {
  for_each = toset(var.redis_cluster_details)
  description = "Redis clusters creation"
  replication_group_id = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))
  #cluster_id           =  substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))
  engine               = var.engine
  node_type            = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2)))
  num_node_groups      = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))
  parameter_group_name = var.parameter_group_name_cluster
  engine_version       = var.engine_version
  port                 = var.port
  # availability_zone    = var.availability_zone[0]
  subnet_group_name    = var.subnet_group_name
  multi_az_enabled = false
  replicas_per_node_group = 1
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  security_group_ids = var.security_group_ids 
  automatic_failover_enabled = true
}

