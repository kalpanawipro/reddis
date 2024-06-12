data "local_file" "repoFile" {
  filename = "${path.module}/files/mongodb.repo"
}

data "local_file" "pemFile" {
  filename = "${path.module}/files/dev-cisco.pem"
}

data "local_file" "confFile" {
  filename = "${path.module}/files/mongodb.conf"
}
data "cloudinit_config" "user-data-mongodb" { 
  # for_each = toset(local.instance_names)
  gzip          = false
  base64_encode = false
  part { 
    filename = "bootstraping.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/files/bootstraping.sh", {  }) 
  } 
  part { 
    filename = "install-mongodb.sh" 
    content_type = "text/x-shellscript"
    content  = templatefile("${path.module}/files/install-mongodb.sh",  { useLocalDisk = "false", mongo_repo = data.local_file.repoFile.content, mongo_conf = data.local_file.confFile.content, pem_file = data.local_file.pemFile.content }) 
  }
}