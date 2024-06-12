module redshift_db_cretion {
    source = "../modules/redshift/"
    availability_zone                   = var.availability_zone[0]
    cluster_identifier                  = var.cluster_identifier #"loc-redshift-cluster"
    cluster_public_key                  = var.cluster_public_key #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCFmhHLb0lguyx9ngg6C7nYLYfGn1nAm9t7+viYIKS55p1xHh1PWK9luc2sN+e+28F3HLiYz1OxSyjzyr4Gt41r4/9J/HhgNk7UdNG/H7wBbjJyxWThXlxDNNqHaXL8C8g2w6h5btYJvWymE06bv7ye8CcmWvbx6881jGnj8yfnJaa8eiq26gL2qSfPAECIG6hBa+cxgXvXXMKXhZmq3BxKC5n3sXT9l2ctmstvVO35nL5Fk8PxKPgiErFqZMG6bSKNFcBIk6AVYHmfLV4cXq/6ZOg64Z4n8i4Qo+xtUWWz17YVOmKufvA94j+vU9XZmyWnSwcdA+anw8SGnL1u0D03 Amazon-Redshift"
    cluster_type                        = "multi-node" #var.cluster_type #"multi-node"
    database_name                       = "dev"
    iam_roles                           = ["arn:aws-us-gov:iam::031661760457:role/redshift-user-role"] #["arn:aws:iam::705697098806:role/history-redshift-role"]
    master_password                     = var.master_password #"qNL2UVQ55F5PA"
    master_username                     = var.master_username #"admin"
    preferred_maintenance_window        = "mon:04:00-mon:04:30"
    security_groups                     = var.security_groups #["sg-0abfb26b920059d68","sg-0a6878e4b2ff6691f"] #var.security_groups #["sg-0a55b64c0e45672ef", "sg-001fcf8918cde4ba8"]
    subnet_ids                          = var.subnet_ids #["subnet-036c7562472411cde","subnet-0ddc2a3278b9cf5e9"]#var.subnet_ids #["subnet-037e4acc201a1306c", "subnet-01d772cacb4dab399"]
}
