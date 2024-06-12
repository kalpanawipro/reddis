variable "availability_zone"{
  type = list
}

variable "cluster_identifier"{
  type = list
}
variable "cluster_public_key"{
  type = string
}

variable "cluster_type"{
  type = string
}

variable "iam_roles"{
  type = list
}

variable "master_password"{
  type = string
}

variable "master_username"{
  type = string
}

variable "security_groups"{
  type = list
}

variable "subnet_ids" {
  type = list
}