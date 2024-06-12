data "aws_secretsmanager_secret" "influx-secretmanager" {
  arn = "arn:aws-us-gov:secretsmanager:us-gov-west-1:031661760457:secret:influxdb/secrets/govcloud-uIyg1q"
}

data "aws_secretsmanager_secret_version" "influx-secret-val" {
  secret_id = data.aws_secretsmanager_secret.influx-secretmanager.id
}

data "external" "json" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.influx-secret-val.secret_string}"]
}

data "local_file" "repoFile" {
  filename = "${path.module}/files/influxdb.repo"
}

data "local_file" "confFile" {
  filename = "${path.module}/files/relay.conf"
}

data "cloudinit_config" "user-data-influxdb" { 
  # for_each = toset(local.instance_names)
  count = var.total_instance_count
  gzip          = false
  base64_encode = false
  part { 
    filename = "bootstraping.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/scripts/bootstraping.sh", { hostname = "${var.instance_name}-${count.index}", endpoint_influx=var.endpoint_influx }) 
  } 
  part { 
    filename = "open-ip-tables.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/scripts/open-ip-tables.sh", {}) 
  } 
  part { 
    filename = "setup_repo.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/scripts/setup_repo.sh",  { content = data.local_file.repoFile.content, relayConf = data.local_file.confFile.content}) 
  }
  part { 
    filename = "install-influxdb.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/scripts/install-influxdb.sh",  { content = data.local_file.repoFile.content, osver = var.influxdb_os, influxdb_memory_limit = var.influxdb_memory_limit, data_device_name = "${var.influxdb_data_device}", wal_device_name = "${var.influxdb_wal_device}" , data_mount_point = var.influxdb_data_mount , wal_mount_point = var.influxdb_wal_mount , admin = data.external.json.result.admin_user , password = data.external.json.result.admin_password, org = var.org,  useLocalDisk = var.useLocalDisk, token_details=data.external.json.result.token_details, bucket_name=var.bucket_name }) 
  }
  part { 
    filename = "setup-influxdb-dms-v2.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/scripts/setup-influxdb-dms-v2.sh",  { dbname = data.external.json.result.dbname, admin_password = data.external.json.result.admin_password , user = data.external.json.result.user_name, password= data.external.json.result.user_password, org = var.org, retention_period = var.retention_period, token_details=data.external.json.result.token_details, bucket_name=var.bucket_name  }) 
  }
}