module "kafka_instance_creation" {
    source = "../modules/kafka"
    instance_ami = var.instance_ami
    ssl_enabled = var.ssl_enabled
    instance_type = var.instance_type
    key_name = var.key_name
    instance_profile = var.iam_instance_profile
    subnet = var.subnet_id
    security_groups = var.security_groups
    useLocalDisk = var.useLocalDisk
    instance_list_kafka = var.instance_list_kafka
}