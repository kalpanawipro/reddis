module msk_cluster {
    source = "../modules/msk/"
    for_each = toset(var.cluster_broker_map) #{ for idx, record in var.cluster_broker_map : idx => record }
    msk_instanceType = substr(element(split(":", each.key), 2), 0 , length(element(split(":", each.key), 2))) #var.msk_instanceType #"kafka.m5.large"
    azs = local.ads
    subnet_id_msk = var.subnet_id_msk
    security_groups_msk = var.security_groups_msk
    totalNodeMsk = substr(element(split(":", each.key), 1), 0 , length(element(split(":", each.key), 1)))  #length(element(split(":", each.key), 0)))
    encryptionInfo = var.encryptionInfo
    clusterName = substr(element(split(":", each.key), 0), 0 , length(element(split(":", each.key), 0))) 
}

locals {
    ads = data.aws_availability_zones.ads.names

}

data "aws_availability_zones" "ads" {
  state = "available"
  filter {
    name = "zone-name"
    values = ["us-gov-west-1a","us-gov-west-1b","us-gov-west-1c"]
  }
}