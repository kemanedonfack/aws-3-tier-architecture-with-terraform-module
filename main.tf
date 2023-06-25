provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

module "network" {
  source                     = "./modules/network"
  vpc_cidr                   = "10.0.0.0/16"
  vpc_name                   = "3-tier-vpc"
  igw_name                   = "us-east-2-gw"
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  private_subnet_cidr_blocks = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zones         = ["eu-north-1a", "eu-north-1b"]
  public_subnet_name_prefix  = "public-subnet"
  private_subnet_name_prefix = "private-subnet"
  public_rt_name             = "public-rt"
  private_rt_name            = "private-rt"
}

module "security_group_database" {
  source              = "./modules/securitygroup"
  security_group_name = "database-sg"
  inbound_port        = [3306]
  vpc_id              = module.network.vpc_id
}

module "security_group_alb" {
  source              = "./modules/securitygroup"
  security_group_name = "alb-sg"
  inbound_port        = [80]
  vpc_id              = module.network.vpc_id
}

module "database" {
  source             = "./modules/database"
  db_subnet_name     = "db-group-subnet"
  subnet_ids         = [module.network.private_subnet_ids[0], module.network.private_subnet_ids[1]]
  db_identifier      = "awstier"
  db_name            = "tutorials"
  db_user            = "root"
  db_password        = "Wordpress-AWS3Tier"
  db_engine          = "mysql"
  db_version         = "5.7.37"
  db_instance_class  = "db.t3.micro"
  availability_zones = ["eu-north-1a", "eu-north-1b"]
  database_sg_id     = module.security_group_database.security_group_id
}

module "security_group_ec2" {
  source              = "./modules/securitygroup"
  security_group_name = "ec2-sg"
  inbound_port        = [22, 80]
  vpc_id              = module.network.vpc_id
}

module "alb_backend" {
  source                = "./modules/alb"
  alb_name              = "Backend-ALB"
  alb_sg_id             = module.security_group_alb.security_group_id
  alb_subnet_ids        = [module.network.public_subnet_ids[0], module.network.public_subnet_ids[1]]
  targetgroup_name      = "Backend-TG"
  vpc_id                = module.network.vpc_id
  alb_internal          = false
  healthy_threshold     = 2
  unhealthy_threshold   = 5
  health_check_interval = 30
  health_check_path     = "/api/tutorials"
  health_check_timeout  = 10
}

module "ec2_backend" {
  source               = "./modules/ec2"
  template_name        = "BackendTemplate"
  ami                  = "ami-08766f81ab52792ce"
  key_name             = "kemane"
  instance_type        = "t3.micro"
  userdata             = "backend_userdata.tpl"
  api_url              = null
  dbpassword           = module.database.database_password
  dbuser               = module.database.database_username
  dbendpoint           = module.database.database_endpoint
  dbname               = module.database.database_name
  ec2_sg_id            = module.security_group_ec2.security_group_id
  public_subnet_ids    = [module.network.public_subnet_ids[0], module.network.public_subnet_ids[1]]
  asg_name             = "Backend-ASG"
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  alb_target_group_arn = module.alb_backend.alb_target_group_arn

}

module "alb_frontend" {
  source                = "./modules/alb"
  alb_name              = "Frontend-ALB"
  alb_sg_id             = module.security_group_alb.security_group_id
  alb_subnet_ids        = [module.network.public_subnet_ids[2], module.network.public_subnet_ids[3]]
  targetgroup_name      = "Frontend-TG"
  vpc_id                = module.network.vpc_id
  alb_internal          = false
  healthy_threshold     = 2
  unhealthy_threshold   = 5
  health_check_interval = 30
  health_check_path     = "/"
  health_check_timeout  = 10
}

module "ec2_frontend" {
  source               = "./modules/ec2"
  template_name        = "FrontendTemplate"
  ami                  = "ami-08766f81ab52792ce"
  key_name             = "kemane"
  instance_type        = "t3.micro"
  userdata             = "frontend_userdata.tpl"
  api_url              = module.alb_backend.elb_dns_name
  dbpassword           = null
  dbuser               = null
  dbendpoint           = null
  dbname               = null
  ec2_sg_id            = module.security_group_ec2.security_group_id
  public_subnet_ids    = [module.network.public_subnet_ids[2], module.network.public_subnet_ids[3]]
  asg_name             = "Frontend-ASG"
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  alb_target_group_arn = module.alb_frontend.alb_target_group_arn

}