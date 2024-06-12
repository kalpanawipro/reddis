variable "secretPassword" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "license_model" {
  type = string
}

variable "maintainence_window" {
  type = string
}

variable "identifier" {
  type = list
}

variable "subnet_id_rds" {
  type = list
}

variable "subnet_group_name" {
  type = string
}

variable "security_groups_rds" {
  type = list
}

variable "aurora_identifier" {
  type = list
}