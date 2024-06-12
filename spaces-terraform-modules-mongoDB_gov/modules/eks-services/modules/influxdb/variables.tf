# variable "tag" {
#   type = string
# }

# variable "seed_tag" {
#   type = string
# }

# variable "totalInstances" {

# }

variable "azs" {
#   default = ["us-east-1a", "us-east-1b", "us-east-1e"]
}

variable "instance_profile" {
  type = string
}

variable "subnet_id" {
    type = list
}

variable "security_groups" {
  type = list
}

variable "key_name" {
  type = string
}

variable "instance_ami" {
    type = string
}

variable "instance_type" {
  type = string
}

variable "application_name" {
  default =  "DNASpaces"
}

variable "mail_alias" {
  default = "dnaspaces-aws@cisco.com"
}

variable "data_class" {
  default = "Cisco Confidential"
}

variable "environment" {
  default = "prod"
}

# varibale "app_name" {
#   default = ""
# }
variable "Owner" {
  default = "DNASpaces-AWS"
}

variable "Business_Offering" {
  default = "Platform"
}

variable "Operation_Type" {
  default = "Production"
}

variable "Component" {
  default = "Kafka"
}

variable "Service" {
  default = "Kafka"
}

variable "SUB_Category" {
  default = "Common"
}


variable "instance_val" {
  type = list
  default = ["kafka200-kafka203", "kafka100-kafka102"]
}

variable "commontags" {
  default = [
    {
      key                 = "Application Name"
      value               = "DNASpaces"
      propagate_at_launch = true
    },
    {
      key                 = "Cisco Mail Alias"
      value               = "dnaspaces-aws@cisco.com"
      propagate_at_launch = true
    },
    {
      key                 = "Data Classification"
      value               = "Cisco Confidential"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "DNASpaces"
      propagate_at_launch = true
    },
    {
      key                 = "Application Name"
      value               = "Prod"
      propagate_at_launch = true
    },
    {
      key                 = "Resource Owner"
      value               = "DNASpaces-AWS"
      propagate_at_launch = true
    },
    {
      key                 = "Business_Offering"
      value               = "Platform"
      propagate_at_launch = true
    },
    {
      key                 = "Operation_Type"
      value               = "Production"
      propagate_at_launch = true
    },
    {
      key                 = "Component"
      value               = "Cassandra"
      propagate_at_launch = true
    },
    {
      key                 = "SUB_Category"
      value               = "Common"
      propagate_at_launch = true
    },
  ]
}


variable "enable_ha" {
  description = "flag to enable an HA configuration"
  default = false
}

variable "influxdb_os" {
  description = "Amazon Linux version"
  default = "2016.09"
}

variable "influxdb_data_device" {
  description = "device for the influxdb data volume"
  default = "/dev/xvdf"
}

# variable "influxdb_data_volume_ids" {
#   type = "list"
#   description = "EBS volumes for data"
# }

variable "influxdb_wal_device" {
  description = "device for the influxdb write ahead log volume"
  default = "/dev/xvdg"
}

# variable "influxdb_wal_volume_ids" {
#   type = "list"
#   description = "EBS volumes for write ahead logs"
# }

variable "influxdb_memory_limit" {
  description = "Memory limit for influx servers"
  default = 1580000
}

variable "influxdb_data_mount" {
  description = "mount point for the influxdb data volume"
  default = "/var/lib/influxdb/data"
}

variable "influxdb_wal_mount" {
  description = "mount point for the infuxdb write ahead log volume"
  default = "/var/lib/influxdb/wal"
}

variable "admin_user" {
  type = string
  description = "admin username"
  default = "test"
}

# variable "admin_password" {
#   type = string
#   description = "admin password"
#   default = "test"
# }

variable "user" {
  type = string
  default = "test"
}

# variable "password" {
#   type = string
#   default = "test"
# }

variable "dbname" {
  type = string
  default = "testDB"
}

variable "org" {
  type = string
  default = "spaces"
}

variable "retention_period" {
  type = string
  default = "10h"
}

variable "useLocalDisk" {
  type = string
  default = "false"
}

variable "query_priority" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "total_count" {
  type = string
}

variable "bucket_name" {
  type = string
}
variable "endpoint_influx" {
  type = string
}

# variable "influxdb_details" {
#   type = list
# }

variable "instance_name" {
  type = string
}

variable "total_instance_count" {
  type = string
}

variable "targetGroup_name" {
  type = string
}