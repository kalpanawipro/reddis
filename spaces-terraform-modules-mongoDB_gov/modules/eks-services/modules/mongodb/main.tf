resource "aws_instance" "mongodb_master_node" {
  ami                    = var.instance_ami
  instance_type          = var.master_instanceType
  key_name               = var.key_name
  availability_zone      = var.azs[0]
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id[0]
  vpc_security_group_ids = var.security_groups
  user_data              = "${(data.cloudinit_config.user-data-mongodb.rendered)}"

  volume_tags = { volume_tag : "govcloud_ebs_terraform" }
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_type           = "gp3"
    iops                  = 3000
    volume_size           = 500
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = "arn:aws-us-gov:kms:us-gov-west-1:031661760457:key/05e35e7e-afae-4e53-8e56-9bcf692c99dd"
  }
  tags = {
    "Application Name"    = var.application_name
    "Cisco Mail Alias"    = var.mail_alias
    "Data Classification" = var.data_class
    Environment           = var.environment
    "Resource Owner"      = var.Owner
    Business_Offering     = var.Business_Offering
    Operation_Type        = var.Operation_Type
    Component             = var.Component
    SUB_Category          = var.SUB_Category
    Name                  = "mongodb_master_node_terr"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_instance" "mongodb_slave_node" {
  ami                    = var.instance_ami
  instance_type          = var.slave_instanceType
  key_name               = var.key_name
  availability_zone      = var.azs[0]
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id[0]
  vpc_security_group_ids = var.security_groups
  user_data              = "${(data.cloudinit_config.user-data-mongodb.rendered)}"

  volume_tags = { volume_tag : "govcloud_ebs_terraform" }
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_type           = "gp3"
    iops                  = 3000
    volume_size           = 500
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = "arn:aws-us-gov:kms:us-gov-west-1:031661760457:key/05e35e7e-afae-4e53-8e56-9bcf692c99dd"
  }
  tags = {
    "Application Name"    = var.application_name
    "Cisco Mail Alias"    = var.mail_alias
    "Data Classification" = var.data_class
    Environment           = var.environment
    "Resource Owner"      = var.Owner
    Business_Offering     = var.Business_Offering
    Operation_Type        = var.Operation_Type
    Component             = var.Component
    SUB_Category          = var.SUB_Category
    Name                  = "mongodb_slave_node_terr"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_instance" "mongodb_arbitrary_node" {
  ami                    = var.instance_ami
  instance_type          = var.arbitary_instanceType
  key_name               = var.key_name
  availability_zone      = var.azs[0]
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id[0]
  vpc_security_group_ids = var.security_groups
  user_data              = "${(data.cloudinit_config.user-data-mongodb.rendered)}"

  volume_tags = { volume_tag : "govcloud_ebs_terraform" }
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_type           = "gp3"
    iops                  = 3000
    volume_size           = 500
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = "arn:aws-us-gov:kms:us-gov-west-1:031661760457:key/05e35e7e-afae-4e53-8e56-9bcf692c99dd"
  }
  tags = {
    "Application Name"    = var.application_name
    "Cisco Mail Alias"    = var.mail_alias
    "Data Classification" = var.data_class
    Environment           = var.environment
    "Resource Owner"      = var.Owner
    Business_Offering     = var.Business_Offering
    Operation_Type        = var.Operation_Type
    Component             = var.Component
    SUB_Category          = var.SUB_Category
    Name                  = "mongodb_arbitrary_node_terr"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}