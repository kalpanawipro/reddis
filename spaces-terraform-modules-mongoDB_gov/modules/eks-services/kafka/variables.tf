variable "region" {
  type = string
  default = "us-east-1"
}

variable "environment" {
  type = string
  default = "DEV"
}

# variable "instance_type" {
#   type = string
#   # default = "i3.xlarge"
#   default = "im4gn.xlarge"
# }

variable "key_name" {
  type = string
  default = "ciscospaces-sg-live"
  # default = "dnas-qa-devops"
}

variable "iam_instance_profile" {
  type = string
  default = "dnaspaces_general_role"
  # default = "techOps-Infra-Staging"
}

variable "tag" {
  default = "cassandra"
}

variable "seed_tag" {
  default = "cassandra_seed"
}

variable "instance_ami" {
  type = string
  # default = "ami-04d62552c6abc0edf"
}

variable "as_min_size" {
  default = "3"
}

variable "as_max_size" {
  default = "10"
}

variable "subnet_id" {
    type = list
  # default = ["subnet-07bb2456dba0c60d3", "subnet-048680dc28448ef7c", "subnet-0b879e9a7830e0512"]  #QA
 # default = ["subnet-06907306b35b9922e", "subnet-0660df7ea1aa26093", "subnet-0c26ab4338d84a007"]
}

variable "security_groups" {
  type = list
  # default = ["sg-01c0c29a26af1ba04"]
  #default = ["sg-0dcce4f3cd79d563a", "sg-040aad367e838f54e"]
}

variable "instance_type" {
  type = string
}

variable "ssl_enabled" {
  type = string
}

variable "useLocalDisk" {
  type = string
}

variable "instance_list_kafka" {
  type = list
}