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

module "security_group_ec2" {
  source              = "./modules/securitygroup"
  security_group_name = "ec2-sg"
  inbound_port        = [22, 80]
  vpc_id              = module.network.vpc_id
}


module "database" {
  source             = "./modules/database"
  db_subnet_name     = "db-group-subnet"
  subnet_ids         = module.network.private_subnet_ids
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
