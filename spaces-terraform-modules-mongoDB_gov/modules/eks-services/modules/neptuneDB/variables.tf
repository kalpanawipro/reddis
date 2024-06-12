variable "instance_class" {
  type = string
}

variable "num_instance" {
  type = string
}

variable "cluster_identifier" {
  type = string
}

variable "vpc_security_group_neptunedb" {
  type = list
}

variable "subnet_id_ndb" {
  type = list
}

variable "subnet_group_name_ndb" {
  type = string
}

variable "neptune_subnet_group_name" {
  type = string
}