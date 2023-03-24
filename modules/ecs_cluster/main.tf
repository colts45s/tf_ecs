# modules/ecs_cluster/main.tf

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = var.cluster_name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.cluster_name}-tasks-sg"
  description = "Security group for ECS tasks within the cluster"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_tasks_egress" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
