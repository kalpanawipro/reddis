variable "subnet_id_rds" {
  type = list
}

variable "cluster_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "security_groups_rds" {
  type = list
}

variable "instance_class" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}