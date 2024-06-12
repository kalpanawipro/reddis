variable "msk_instanceType" {
  type = string
}

variable "azs" {
  type = list
}

variable "encryptionInfo" {
  type = string
}

variable "totalNodeMsk" {
  type = string
}

variable "clusterName" {
  type = string
}

variable "security_groups_msk" {
  type = list
}

variable "subnet_id_msk" {
  type = list
}