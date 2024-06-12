data "local_file" "brokerFile" {
  filename = "${path.module}/files/broker.sh"
}

data "cloudinit_config" "user-data" { 
  for_each = toset(local.instance_names)
  gzip          = false
  base64_encode = false
  part { 
    filename = "bootstraping.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/files/bootstraping.sh", { hostname = "${each.key}" }) 
  } 
  part { 
    filename = "kafka_setup.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/files/kafka_setup.sh",  { totalInstance = local.total_instance , brokerID = index(local.instance_names, each.key), kafka_script = data.local_file.brokerFile.content, clusterName= local.clusterName, totalHosts = local.instance_names, ssl_enabled=var.ssl_enabled, first_set=local.instance_names[0], useLocalDisk = "true" }) 
  }
}
