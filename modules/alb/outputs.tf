output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "elb_dns_name" {
  value = "http://${aws_lb.alb.dns_name}/api/tutorials"
}
