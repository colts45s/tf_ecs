# Output

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "ecs_security_group_id" {
  description = "Security group ID for the ECS tasks"
  value       = aws_security_group.ecs_tasks_sg.id
}