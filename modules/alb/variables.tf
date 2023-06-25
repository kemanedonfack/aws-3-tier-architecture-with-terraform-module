variable "alb_name" {
  description = "ALB name"
}
variable "alb_sg_id"{
    description = "ALB security group id"
}
variable "alb_subnet_ids"{
    description = "Id for the subnets where the abl can span"
}
variable "targetgroup_name"{
    description = "Target group name"
}
