variable "instance_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "subnet_id" {
  type = list
}

variable "security_groups" {
  type = list
}
