variable "template_name" {
  description = "Launch template name"
}
variable "ami" {
  description = "EC2 ami"
}
variable "key_name" {
  description = "ssh key name"
}
variable "instance_type" {
  description = "EC2 instance type"
}
variable "dbpassword" {
  description = "Database password"
}
variable "dbuser" {
  description = "Database user"
}
variable "dbendpoint" {
  description = "Database endpoint"
}
variable "dbname" {
  description = "Database name"
}
variable "ec2_sg_id" {
  description = "Database version"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "List public subnet for ec2"
}
variable "asg_name" {
  description = "Database endpoint"
}
variable "min_size" {
  description = "Database name"
}
variable "max_size" {
  description = "Database name"
}
variable "desired_capacity" {
  description = "Database name"
}
variable "alb_target_group_arn" {
  description = "Target Group arn for form Application loadbalancer"
}
variable "userdata" {
  description = "name of userdata file to use"
}
variable "api_url" {
  description = "endpoint to the backend load balancer"
}
