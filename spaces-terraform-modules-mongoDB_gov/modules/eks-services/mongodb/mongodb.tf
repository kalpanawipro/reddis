module mongodb_cluster {
    source = "../modules/mongodb/"
    master_instanceType = "m6g.large"
    slave_instanceType = "m6g.large"
    arbitary_instanceType = "m6g.medium"    
    azs = local.ads
    instance_ami = var.instance_ami
    key_name = var.key_name
    iam_instance_profile = var.iam_instance_profile
    subnet_id = var.subnet_id
    security_groups = var.security_groups
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