locals {
  instance_list_kafka = var.instance_list_kafka #split("\n", file("${path.module}/files/kafka_instance_broker.config") )
  parsed_ranges = [ for r in local.instance_list_kafka : {
    instance_name = substr(element(split("|", r), 0),0,length(element(split("|", r), 0)))
    instance_type = substr(element(split("|", r), 1),0,length(element(split("|", r), 1)))
  }]

  parsed_var = [for parseVar in local.parsed_ranges : { 
      prefix = substr(parseVar.instance_name, 0, "${length(element(split(":", parseVar.instance_name), 0)) - 3}")
      start_number = tonumber(substr(element(split(":", parseVar.instance_name), 0), "${length(element(split(":", parseVar.instance_name), 0)) - 3}", length(element(split(":", parseVar.instance_name), 0))))
      end_number   = tonumber(substr(element(split(":", parseVar.instance_name), 1), "${length(element(split(":", parseVar.instance_name), 0)) - 3}", length(element(split(":", parseVar.instance_name), 1))))
      instance_type = parseVar.instance_type
  } ]

  instance_names = flatten([
    for pr in local.parsed_var : [
      for i in range(pr.start_number, pr.end_number + 1) : ["${pr.prefix}${i}:${pr.instance_type}"]
    ]
  ])  

  total_instance = length(local.instance_names)
  hostname_prefix = "terraform_instance"
  clusterName = "sgwebex-kafka"
  }


resource "aws_instance" "kafka_ec2_creation" {
  for_each = toset(local.instance_names)
  ami                    = var.instance_ami
  instance_type          = substr(element(split(":", each.key), 1), 0 ,length(element(split(":", each.key), 1)))  #var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile
  subnet_id              = var.subnet[0]
  vpc_security_group_ids = var.security_groups
  user_data              = "${(data.cloudinit_config.user-data[each.key].rendered)}" #templatefile("${path.module}/files/kafka_setup.sh", { countValue = count.index, totalInstance = var.countVal , brokerID = count.index, kafka_script = data.local_file.brokerFile.content, cluster_name= var.clusterName })
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

  ebs_optimized = "true"
  instance_initiated_shutdown_behavior = "stop"

  maintenance_options {
    auto_recovery = "default"
  }
 tags = {
    Name = substr(element(split(":", each.key), 0), 0 ,length(element(split(":", each.key), 0))) #"${each.key}"
  }
  monitoring = "false"
  volume_tags = { volume_tag : "kafka_ebs_terraform" }
  tags_all = {
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
}