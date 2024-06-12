# variable "tag" {
#   type = string
# }

# variable "seed_tag" {
#   type = string
# }

# variable "totalInstances" {

# }

variable "instance_profile" {
  type = string
}

variable "subnet" {
    type = list
#   default = ["subnet-067e146a6828f6803", "subnet-0f55d1be1c0047206", "subnet-0d05323fe832f5b7b"]
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
  default = "Prod"
}

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

variable "instance_list_kafka" {
  type = list
}

variable "SUB_Category" {
  default = "Common"
}

# variable "kafka_naming_map" {
#   type = map
# }

# variable "clusterName" {
#   type = string
# }

# variable "countVal" {
#   type = string 
# }

# variable "as_min_size" {
#   type = string
# }

# variable "as_max_size" {
#   type = string
# }

# variable "application_name" {
#   type = string
# }

#Autoscaling policy

# variable "scaling_up_adjustment" {
#   type = string
# }

# variable "scaling_down_adjustment" {
#   type = string
# }
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

variable "instance_val" {
  type = list
  default = ["kafka100-kafka104"]
}

variable "ssl_enabled" {
  type = string
}

variable "useLocalDisk" {
  type = string
}