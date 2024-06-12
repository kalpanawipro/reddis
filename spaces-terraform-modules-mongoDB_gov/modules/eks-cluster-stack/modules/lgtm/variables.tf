variable "loki_bucket_name" {
  type        = string
  description = "Bucket name for Loki S3 bucket"
  default     = "sandbox-eks-loki"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "sandbox"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN of EKS cluster"
}

variable "acm_certificate_arn" {
  type = string
}
