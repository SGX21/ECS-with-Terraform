# Define the Application Load Balancer (ALB)
resource "aws_lb" "test-lb" {
  name               = "simple-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb.id]

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# Define the security group for the ALB
resource "aws_security_group" "lb" {
  name   = "allow-lb"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# Define the target group for the ALB
resource "aws_lb_target_group" "lb_target_group" {
  name     = "simple-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}

# Define the listener for the ALB
resource "aws_lb_listener" "webapp-listener" {
  load_balancer_arn = aws_lb.test-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}
