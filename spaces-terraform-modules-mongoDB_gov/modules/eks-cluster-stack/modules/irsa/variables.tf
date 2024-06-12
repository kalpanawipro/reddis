variable "role_name" {
  type        = string
  description = "IRSA roles name"
}
variable "allowed_actions" {
  type        = list(string)
  default     = []
  description = "Allowed actions"
}
variable "resources" {
  type        = list(string)
  default     = []
  description = "Actioned allowed on resources"
}
variable "eks_oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN of EKS cluster"
}
variable "environment" {
  type        = string
  description = "Environment"
}
