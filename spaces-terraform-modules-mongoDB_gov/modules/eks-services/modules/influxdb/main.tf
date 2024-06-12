/*
 * InfluxDB instances.
 */
locals {
  influxdb_names = [
    "eks-sandbox-influxdb-01",
    # "clsv3-influx-arm-primary-influxdb-02",
    # "apigateway-${var.environment}-influxdb-02"
    # "rightnow-${var.environment}-influxdb-eu-02"
  ]
}

resource "aws_instance" "influxdb-nodes" {
  count = var.total_instance_count //"${var.enable_ha ? 2 : 1}"
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = "${var.key_name}"
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = var.security_groups
  subnet_id = var.subnet_id[0]
  ebs_optimized = true
  user_data              = "${(data.cloudinit_config.user-data-influxdb[count.index].rendered)}"
  tags = {
    Name = "${var.instance_name}-${count.index}"  #"${local.influxdb_names[count.index]}"
    "Application Name"    = var.application_name
    "Cisco Mail Alias"    = var.mail_alias
    "Data Classification" = var.data_class
    Environment           = var.environment
    "Resource Owner"      = var.Owner
    Business_Offering     = var.Business_Offering
    Operation_Type        = var.Operation_Type
    Component             = var.Component
    SUB_Category          = var.SUB_Category
    Service               = var.Service
  }
  dynamic ebs_block_device {
    for_each = var.useLocalDisk=="false" ? [1] : []
    content {
    device_name           = "/dev/sdf"
    encrypted             = "true"
    throughput  = "0"
    volume_size = "500"
    volume_type = "gp2"
    delete_on_termination = true
    }
  }
}
