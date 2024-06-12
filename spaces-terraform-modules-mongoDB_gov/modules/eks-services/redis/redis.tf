module redis_cretion {
    source = "../modules/redis/"
    cluster_id                            = var.cluster_id #"gov-cloud-redis"
    engine                                = var.engine  #"redis"
   # node_type                             = var.node_type  #"cache.m6g.large"
    # num_cache_nodes                       = var.num_cache_nodes  #"1"
    parameter_group_name                  = var.parameter_group_name   #"default.redis7"
    parameter_group_name_cluster                  = var.parameter_group_name_cluster   #"default.redis7"
    engine_version                        = var.engine_version  #"7.1"
    port                                  = var.port  #"6379"
    availability_zone                     = var.availability_zone  #["us-gov-west-1a", "us-gov-west-1b", "us-gov-west-1c"]
    subnet_group_name                      = aws_elasticache_subnet_group.redisSubnet.id #var.subnet_group_name #"redis-commons"
    security_group_ids                     = var.security_group_ids 
    redis_cluster_details                 = var.redis_cluster_details
}

resource "aws_elasticache_subnet_group" "redisSubnet" {
  description = "redis-opstack-subnetgroup"
  name        = "redis-opstack-subnetgroup"
  subnet_ids  = var.subnet_id
}