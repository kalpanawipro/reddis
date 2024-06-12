module "instance_creation_onlyinfluxdb" {
    source = "../modules/influxdb"
    for_each = toset(var.influxdb_details)
    azs = local.ads
    instance_ami = var.instance_ami
    instance_type = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0))) #var.instance_type
    key_name = var.key_name
    instance_profile = var.iam_instance_profile
    subnet_id = var.subnet_id
    security_groups = var.security_groups
    query_priority = "100"
    listener_arn = var.listener_arn
    useLocalDisk = var.useLocalDisk
    total_count = "1"
    total_instance_count = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))
    bucket_name = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2))) 
    endpoint_influx = substr(element(split(":", each.key), 3), 0 , length(element(split(":", each.key), 3))) #var.endpoint_influx
    instance_name = substr(element(split(":", each.key), 4), 0 , length(element(split(":", each.key), 4))) #var.endpoint_influx
    targetGroup_name = substr(element(split(":", each.key), 5), 0 , length(element(split(":", each.key), 5))) #var.endpoint_influx
}