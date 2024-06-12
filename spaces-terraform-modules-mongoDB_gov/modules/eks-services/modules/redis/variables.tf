variable "cluster_id"{
  type = list
}

variable "engine"{
  type = string
}

# variable "node_type"{
#   type = string
# }

# variable "num_cache_nodes"{
#   type = string
# }

variable "parameter_group_name"{
  type = string
}

variable "engine_version"{
  type = string
}

variable "port"{
  type = string
}

variable "availability_zone"{
  type = list
}

variable "parameter_group_name_cluster" {
  type = string
}

variable "subnet_group_name" {
  type = string
}

variable "security_group_ids" {
  type = list
}

variable "redis_cluster_details" {
  type = list
}