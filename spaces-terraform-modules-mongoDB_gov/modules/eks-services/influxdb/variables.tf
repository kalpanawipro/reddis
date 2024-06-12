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
#   #default = "r7gd.2xlarge"
# }

  # variable "key_name" {
  #   type = string
  #   default = "dnaspaces"
  # }

# variable "iam_instance_profile" {
#   type = string
#   default = "dnaspaces_general_role"
# }

variable "instance_ami" {
  #default =  "ami-0be10152e6aa34b53"
}

# variable "instance_type" {
#   default = "i3.xlarge"
# }

variable "as_min_size" {
  default = "3"
}

variable "as_max_size" {
  default = "10"
}

variable "vpc_id" {
  default = "vpc-03311145389b1f2c0"
}

variable "subnet_id" {
  type = list
}

variable "security_groups" {
  type = list
  # default = ["sg-01c0c29a26af1ba04"]
  # default = ["sg-0b03b19bd74e7d63f"]
  #default = ["sg-0f965b48a2b92b92b", "sg-0a0704efb66b73d7a"]
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "useLocalDisk" {
  type = string
}

# variable "bucket_name" {
#   type = string
# }

# variable "endpoint_influx" {
#   type = string
# }

variable "influxdb_details" {
  type = list
}