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
  app_port    = var.demo_app_port
}

module "ec2" {
  source = "../../modules/ec2"

  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  ec2_security_group_id = module.security.ec2_security_group_id
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  app_port             = var.demo_app_port
}
