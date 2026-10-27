# Variables used by Terraform modules

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "AWS CLI profile used for authentication"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "Name of the EKS cluster to be created"
  type        = string
  default     = "teste_remessa"
}
