locals {
  task_family = "cloud9-task"
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "cloud9" {
  family                = local.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = aws_iam_role.ecs_execution_role.arn
  task_role_arn         = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "cloud9"
    image = "lscr.io/linuxserver/cloud9:latest"

    cpu = 256
    memory = 512

    essential = true

    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution_role.name
}


resource "aws_security_group" "cloud9_sg" {
  name        = "cloud9-sg"
  description = "Security group for Cloud9 container access"
  vpc_id      = "vpc-00beea2ab6f09db53"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "cloud9_service" {
  name            = "cloud9-service"
  cluster         = local.cluster_name
  task_definition = aws_ecs_task_definition.cloud9.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-073f6b1149bc6ef5a","subnet-05eb9ad43a44d6d68","subnet-039fbffea5442b5d6"]
    security_groups  = [aws_security_group.cloud9_sg.id]
    assign_public_ip = false
  }

  depends_on = [aws_ecs_task_definition.cloud9]
}
