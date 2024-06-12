module redshift_db_cretion {
    source = "../modules/security_groups/"
    for_each = toset(var.vpc_id)
    vpc_id = each.key
}
