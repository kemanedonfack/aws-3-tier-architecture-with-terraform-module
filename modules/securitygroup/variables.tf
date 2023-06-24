variable "security_group_name" {
  description = "Name of the security group"
}

variable "inbound_port" {
  type        = list(any)
  description = "inbound port allow"
}

variable "vpc_id" {
  description = "VPC id"
}

