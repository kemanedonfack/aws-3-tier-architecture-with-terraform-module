variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}
variable "vpc_name"{
    description = "vpc name tags"
}
variable "igw_name"{
    description = "internet gateway name"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_name_prefix" {
    description = "public subnet name"
}

variable "private_subnet_name_prefix" {
    description = "private subnet name"
}


variable "public_rt_name" {
  description = "public route table name"
}

variable "private_rt_name" {
  description = "private route table name"
}
