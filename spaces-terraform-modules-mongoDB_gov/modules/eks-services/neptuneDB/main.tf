module neptunedb_creation {
    source = "../modules/neptuneDB"
    for_each = toset(var.neptunedb_details)
    instance_class =  substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2)))
    num_instance =  substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))
    cluster_identifier =  substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0)))
    vpc_security_group_neptunedb = var.vpc_security_group_neptunedb 
    subnet_id_ndb = var.subnet_id_ndb
    subnet_group_name_ndb = var.subnet_group_name_ndb
    neptune_subnet_group_name = aws_db_subnet_group.neptuneSubnetGroup.id
}

resource "aws_db_subnet_group" "neptuneSubnetGroup" {
  description = "neptune db subnet group"
  name        = var.subnet_group_name_ndb
  subnet_ids  = var.subnet_id_ndb
}