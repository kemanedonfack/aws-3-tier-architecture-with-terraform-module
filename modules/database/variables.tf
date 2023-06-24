variable "db_subnet_name" {
  description = "Name of the database subnet group"
}
variable "subnet_ids"{
    type        = list(string)
    description = "database private subnets ids"
}
variable "db_identifier"{
    description = "Database identifier"
}
variable "db_name"{
    description = "Database name"
}
variable "db_user"{
    description = "Database user"
}
variable "db_password"{
    description = "Database password"
}
variable "db_engine"{
    description = "Database engine"
}
variable "db_version"{
    description = "Database version"
}
variable "db_instance_class"{
    description = "Database version"
}
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}
variable "database_sg_id" {
    description = "Database security group"
}
