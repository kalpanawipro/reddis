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

variable "master_instanceType" {
  type = string
}

variable "slave_instanceType" {
  type = string
}

variable "arbitary_instanceType" {
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
  default = "Cassandra"
}

variable "SUB_Category" {
  default = "Common"
}

variable "azs" {
  type = list
}

variable "useLocalDisk" {
  type = string
  default = "false"
}