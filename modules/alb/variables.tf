variable "alb_name" {
  description = "ALB name"
}
variable "alb_sg_id" {
  description = "ALB security group id"
}
variable "alb_subnet_ids" {
  description = "Id for the subnets where the abl can span"
}
variable "targetgroup_name" {
  description = "Target group name"
}
variable "alb_internal" {
  type        = bool
  description = "Type of ALB internal or internet facing"
}
variable "vpc_id" {
  description = "VPC id"
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks required to consider a target healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks required to consider a target unhealthy"
  type        = number
}

variable "health_check_interval" {
  description = "Interval between health checks (in seconds)"
  type        = number
}

variable "health_check_path" {
  description = "Path of the health check endpoint"
  type        = string
}

variable "health_check_timeout" {
  description = "Timeout for the health check (in seconds)"
  type        = number
}