# modules/ecs_cluster/variables.tf

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable or disable container insights for the ECS cluster"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where the ECS cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the VPC"
  type        = list(string)
}