variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "clusterName" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "vprofile-eks"
}
######