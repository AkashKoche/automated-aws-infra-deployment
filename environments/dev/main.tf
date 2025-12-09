module "vpc" {
  source = "../../modules/vpc"

  environment         = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  app_port    = var.app_port
}

module "ec2" {
  source = "../../modules/ec2"

  environment          = var.environment
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  vpc_id               = module.vpc.vpc_id
  alb_security_group_id = module.security.alb_security_group_id
  key_name             = module.jenkins_infra.key_pair_name
  ec2_security_group_id = module.security.ec2_security_group_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  target_group_arn     = aws_lb_target_group.demo_app.arn
}

module "jenkins_infra" {
  source = "../../jenkins-infra"

  environment             = var.environment
  jenkins_instance_type   = var.jenkins_instance_type
  public_subnet_id        = module.vpc.public_subnet_ids[0]
  jenkins_security_group_id = module.security.jenkins_security_group_id
}

resource "aws_lb_target_group" "demo_app" {
  name        = "${var.environment}-demo-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id # Uses the VPC ID output from the vpc module

  health_check {
    path                = "/health"
    protocol            = "HTTP"
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
