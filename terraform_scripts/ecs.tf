# ECS Cluster definition
resource "aws_ecs_cluster" "web_cluster" {
  name = var.cluster_name

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family = "web-family"

  # This block is using inline container definitions instead of the `file()` function.
  container_definitions = <<DEFINITION
[
  {
    "name": "my-container",
    "image": "nginx",
    "memory": 128,
    "cpu": 128,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION

  network_mode = "bridge"

  requires_compatibilities = ["EC2"] # Ensuring EC2 launch type compatibility

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1 # Number of tasks (containers) to run in the ECS cluster

  # Load Balancer configuration to integrate with ALB
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "my-container"
    container_port   = 80
  }

  # Launch ECS tasks using EC2 instances
  launch_type = "EC2"

  # Dependencies - ensure the ALB listener is created before the ECS service
  depends_on = [aws_lb_listener.webapp-listener]

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/web-service"

  retention_in_days = 7 # Optional: Define how long logs are retained
  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}
