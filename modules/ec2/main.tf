resource "aws_launch_template" "demo_app" {
  name_prefix   = "${var.environment}-demo-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.demo.key_name

  vpc_security_group_ids = [var.ec2_security_group_id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    environment = var.environment
    app_port    = var.app_port
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-demo-app"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_autoscaling_group" "demo_app" {
  name               = "${var.environment}-demo-app-asg"
  desired_capacity   = var.instance_count
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.demo_app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.demo_app.arn]

  tag {
    key                 = "Name"
    value               = "${var.environment}-demo-app-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "demo_app" {
  name               = "${var.environment}-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets           = var.public_subnet_ids

  tags = {
    Name        = "${var.environment}-demo-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "demo_app" {
  name     = "${var.environment}-demo-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = var.app_port
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-demo-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "demo_app" {
  load_balancer_arn = aws_lb.demo_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_app.arn
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name               = aws_key_pair.demo.key_name

  user_data = file("${path.module}/jenkins-userdata.sh")

  tags = {
    Name        = "${var.environment}-jenkins-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_key_pair" "demo" {
  key_name   = "${var.environment}-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Name        = "${var.environment}-key-pair"
    Environment = var.environment
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
