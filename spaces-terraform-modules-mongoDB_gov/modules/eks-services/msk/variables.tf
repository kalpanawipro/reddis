variable "encryptionInfo" {
  type = string
}

variable "security_groups_msk" {
  type = list
}

variable "subnet_id_msk" {
  type = list
}

# variable "msk_instanceType" {
#   type = string
# }

variable "cluster_broker_map" {
  type = list
}